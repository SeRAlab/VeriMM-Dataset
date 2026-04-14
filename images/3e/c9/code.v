module EEPROM_Cell (
    input wire clk,
    input wire enable,
    input wire data,
    output reg q
);
    always @(posedge clk) begin
        if (enable) begin
            q <= data; // Write data to EEPROM cell
        end
    end
endmodule