module dma_controller (
    input clk,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // Simple memory array

    always @(posedge clk) begin
        if (start) begin
            memory[dest_addr] <= data_in; // Transfer data
            data_out <= memory[dest_addr]; // Output the transferred data
        end
    end
endmodule