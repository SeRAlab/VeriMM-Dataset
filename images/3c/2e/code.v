module SRAM (
    input [7:0] D,
    input [7:0] A,
    input WE,
    input RE,
    output reg [7:0] Q
);
    reg [7:0] memory [255:0]; // 256 x 8-bit memory

    always @(*) begin
        if (WE) begin
            memory[A] <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory[A]; // Read data from memory
        end
    end
endmodule