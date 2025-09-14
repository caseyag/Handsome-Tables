HTMLWidgets.widget({

  name: 'handsome_table',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        const container = document.getElementById(el.id);
        const expandedCells = {};

        // Track the original column order
        let originalOrder = [...Array(x.columns.length).keys()]; // [0, 1, 2, ...]

        // Track the hidden columns
        let hiddenColumnsList = [];

        const ellipsisRenderer = function(instance, td, row, col, prop, value, cellProperties) {
          const cellKey = `${row}-${col}`;
          const maxLength = 40;
          const isTruncated = value && value.length > maxLength;

          const truncatedText = isTruncated ? value.substring(0, maxLength) : value;
          const fullText = value || '';

          Handsontable.dom.empty(td);

          const isExpanded = expandedCells[cellKey];
          const textElement = document.createElement('span');
          textElement.innerHTML = isExpanded ? fullText : truncatedText;

          if (isTruncated && !isExpanded) {
            const ellipsisElement = document.createElement('span');
            ellipsisElement.innerHTML = '...';
            ellipsisElement.style.cursor = 'pointer';
            ellipsisElement.style.textDecoration = 'underline';
            ellipsisElement.style.color = '#007bff';

            ellipsisElement.addEventListener('click', function(e) {
              e.stopPropagation();
              expandedCells[cellKey] = true;
              instance.render();
            });

            textElement.appendChild(ellipsisElement);
          }

          td.appendChild(textElement);

          return td;
        };

        function setHotHeight() {
          const containerHeight = window.innerHeight - 100;
          hot.updateSettings({
            height: containerHeight
          });
        }

        // Initialize Handsontable
        const hot = new Handsontable(container, {
          data: HTMLWidgets.dataframeToD3(x.data),
          columns: x.columns.map(col => ({
            ...col,
            minWidth: 150,
            width: 160,
            renderer: ellipsisRenderer
          })),
          filters: true,
          dropdownMenu: ['filter_by_value', 'filter_action_bar'],
          height: 500,
          autoWrapRow: true,
          autoWrapCol: true,
          contextMenu: {
            items: {
              "freeze_column": {},   // Enable "Freeze column"
              "unfreeze_column": {
                name: 'Unfreeze column',
                callback: function(key, selection, clickEvent) {
                  const colIndex = selection.start.col;
                  hot.getPlugin('manualColumnFreeze').unfreezeColumn(colIndex);
                  hot.updateSettings({
                    manualColumnMove: originalOrder
                  });
                  hot.render();
                }
              },
              "hidden_columns_hide": {},  // Enable "Hide column"
              "hidden_columns_show": {}   // Enable "Unhide column"
            }
          },
          manualColumnFreeze: true,
          readOnly: true,
          editor: false,
          width: '100%',
          colHeaders: true,
          manualColumnResize: true,
          autoColumnSize: true,
          wordWrap: true,
          className: 'handsome-table',
          licenseKey: 'non-commercial-and-evaluation',
          hiddenColumns: {
            columns: hiddenColumnsList, // Specify columns to hide initially
            indicators: true  // Enable indicators (arrows) for hidden columns
          }
        });

        // Capture and preserve the original column order when a column is moved
        hot.addHook('beforeColumnMove', function(startCol, endCol) {
          if (startCol !== endCol) {
            const movedColumn = originalOrder.splice(startCol, 1)[0];
            originalOrder.splice(endCol, 0, movedColumn);
          }
        });

        // Ensure the correct order is restored when unfreezing or moving columns
        hot.addHook('afterColumnMove', function(startCol, endCol) {
          hot.updateSettings({
            manualColumnMove: originalOrder
          });
          hot.render();
        });

        // Set the initial height
        setHotHeight();
        window.addEventListener('resize', setHotHeight);

        // Function to hide specific columns programmatically
        function hideColumns(columnsToHide) {
          hiddenColumnsList = columnsToHide;
          hot.getPlugin('hiddenColumns').hideColumns(columnsToHide);
          hot.render();
        }
      },

      resize: function(width, height) {
        // Re-render the widget with the new size if needed
      }

    };
  }
});
