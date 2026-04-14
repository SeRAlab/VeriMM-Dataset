module eeprom_cell(
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire erase,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk) begin
        if (erase) begin
            data_out <= 1'b0; // Reset the stored value
        end else if (write_enable) begin
            data_out <= data_in; // Store the input data
        end
    end
endmodule