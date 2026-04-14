module SRAM_8bit (
    input wire [7:0] D,
    input wire [3:0] A,
    input wire WE,
    output reg [7:0] Q
);
    reg [7:0] memory [0:15]; // 16x8 bit memory

    always @(posedge WE) begin
        memory[A] <= D; // Write operation
    end

    always @(negedge WE) begin
        Q <= memory[A]; // Read operation
    end
endmodule