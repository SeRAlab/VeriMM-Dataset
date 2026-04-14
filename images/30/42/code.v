module dma_controller (
    input clk,
    input reset,
    input enable,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else if (enable) begin
            // Simulate data transfer
            data_out <= data_in; // Transfer data from input to output
        end
    end
endmodule