module EEPROM_Cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in;
        end
        // If write_enable is low, data_out retains its value
    end
endmodule