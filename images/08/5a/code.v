module dma_controller (
    input clk,
    input rst_n,
    input enable,
    input [2:0] channel_select,
    input [7:0] data_in,
    output reg data_transfer_done,
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_transfer_done <= 0;
            data_out <= 8'b0;
        end else if (enable) begin
            data_out <= data_in; // Simulate data transfer
            data_transfer_done <= 1; // Signal that data transfer is done
        end else begin
            data_transfer_done <= 0;
        end
    end
endmodule