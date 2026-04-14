module dma_controller (
    input wire clk,
    input wire [2:0] channel,
    input wire rw, // 0 for read, 1 for write
    output reg [7:0] memory_out,
    input wire [7:0] memory_in // Data to write when rw is 1
);
    reg [7:0] dma_memory [7:0]; // 8 channels of 8-bit data

    always @(posedge clk) begin
        if (rw) begin
            dma_memory[channel] <= memory_in; // Write data
        end else begin
            memory_out <= dma_memory[channel]; // Read data
        end
    end
endmodule