module eeprom_cell (
    input wire clk,
    input wire write_enable,
    input wire erase,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (erase) begin
            data_out <= 8'b0; // Reset to 0
        end else if (write_enable) begin
            data_out <= data_in; // Store input data
        end
    end
endmodule