module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dst_addr,
    input [7:0] data_in,
    output reg done
);
    reg [7:0] memory [0:255]; // Simple memory
    reg [7:0] src, dst;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else if (start) begin
            src <= src_addr;
            dst <= dst_addr;
            memory[dst] <= data_in; // Transfer data
            done <= 1; // Indicate done after transfer
        end
    end
endmodule