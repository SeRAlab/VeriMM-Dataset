module sram16 (
    input wire [15:0] D,
    input wire [3:0] ADDR,
    input wire WE,
    input wire CLK,
    output reg [15:0] Q
);
    reg [15:0] memory [0:15]; // 16x16-bit memory

    always @(posedge CLK) begin
        if (WE) begin
            memory[ADDR] <= D;  // Write data to memory
        end else begin
            Q <= memory[ADDR];  // Read data from memory
        end
    end
endmodule