module eeprom_cell (
    input wire clk,
    input wire we,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= d;
        end
    end
endmodule