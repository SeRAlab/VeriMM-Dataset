module eeprom_cell (
    input [3:0] D,
    input RW,
    input CLK,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (RW) begin
            Q <= D; // Write data to the cell
        end
    end
endmodule