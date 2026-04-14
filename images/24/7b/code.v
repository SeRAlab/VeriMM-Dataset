module eeprom_cell (
    input clk,
    input WE,
    input RE,
    input [3:0] D,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule