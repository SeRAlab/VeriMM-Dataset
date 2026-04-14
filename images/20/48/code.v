module eeprom_cell (
    input wire clk,
    input wire enable,
    input wire set,
    input wire reset,
    output reg data
);

always @(posedge clk) begin
    if (enable) begin
        if (set) begin
            data <= 1'b1; // Write logic '1'
        end else if (reset) begin
            data <= 1'b0; // Write logic '0'
        end
    end
end

endmodule