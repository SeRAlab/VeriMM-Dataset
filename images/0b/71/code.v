module dram_cell (
    input wire [7:0] D,
    output reg [7:0] Q,
    input wire WE,
    input wire RE,
    input wire [2:0] ADDR,
    input wire clk
);
    reg [7:0] memory [0:7]; // 8-bit memory with 8 addresses

    always @(posedge clk) begin
        if (WE) begin
            memory[ADDR] <= D; // Write operation
        end
        if (RE) begin
            Q <= memory[ADDR]; // Read operation
        end
    end
endmodule