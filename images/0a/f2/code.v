module sram_16bit (
    input wire [15:0] D,
    input wire [3:0] A,
    input wire WE,
    output reg [15:0] Q
);
    reg [15:0] memory [15:0]; // 16x16-bit memory

    always @(WE or A or D) begin
        if (WE) begin
            memory[A] <= D; // Write operation
        end else begin
            Q <= memory[A]; // Read operation
        end
    end
endmodule