module eeprom_cell (
    input wire clk,
    input wire reset,
    input wire we,        // write enable
    input wire data_in,   // data input
    output reg data_out   // data output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0; // Initialize cell to 0 on reset
        end else if (we) begin
            data_out <= data_in; // Write data to cell
        end
    end
endmodule