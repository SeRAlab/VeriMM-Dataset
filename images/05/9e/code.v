module dram_cell (
    input wire WE,
    input wire RE,
    input wire [15:0] D_in,
    output reg [15:0] D_out,
    input wire [3:0] addr,
    input wire clk
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory

    always @(posedge clk) begin
        if (WE) begin
            memory[addr] <= D_in; // Write data to memory
        end
        if (RE) begin
            D_out <= memory[addr]; // Read data from memory
        end
    end
endmodule