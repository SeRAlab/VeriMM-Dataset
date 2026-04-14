module sram_cell (
    input [7:0] D,
    input [2:0] A,
    input WE,
    output reg [7:0] Q
);
    reg [7:0] memory [7:0]; // 8-bit wide, 8 cells deep

    always @(posedge WE) begin
        if (WE) begin
            memory[A] <= D; // Write operation
        end
    end

    always @(negedge WE) begin
        Q <= memory[A]; // Read operation
    end
endmodule