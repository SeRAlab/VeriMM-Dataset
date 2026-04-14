module eeprom_cell (
    input wire clk,
    input wire enable,
    input wire d_in,
    output reg d_out
);
    always @(posedge clk) begin
        if (enable) begin
            d_out <= d_in; // Write operation
        end
    end
endmodule