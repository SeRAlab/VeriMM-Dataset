module SRAM_Cell (
    input wire clk,
    input wire WE,
    input wire OE,
    input wire [2:0] A,
    input wire [7:0] D,
    output reg [7:0] Q
);
    reg [7:0] memory [0:7]; // 8 locations of 8 bits each
    
    always @(posedge clk) begin
        if (WE) begin
            memory[A] <= D; // Write data to memory
        end
    end
    
    always @(*) begin
        if (OE) begin
            Q = memory[A]; // Output data from memory
        end else begin
            Q = 8'bz; // High-impedance state
        end
    end
endmodule