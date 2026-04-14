module SRAM_4bit (
    input [3:0] D,
    input [1:0] A,
    input WE,
    output reg [3:0] Q
);
    reg [3:0] memory [0:3]; // 4-bit wide, 4 cells deep

    always @(*) begin
        if (WE) begin
            memory[A] = D; // Write data to memory
        end
        Q = memory[A]; // Read data from memory
    end
endmodule