module dma_controller (
    input clk,
    input rst_n,
    input req_chan1,
    input req_chan2,
    input enable_chan1,
    input enable_chan2,
    output reg done_chan1,
    output reg done_chan2
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_chan1 <= 0;
            done_chan2 <= 0;
        end else begin
            if (enable_chan1 && req_chan1) begin
                done_chan1 <= 1;  // Data transfer done for channel 1
            end else begin
                done_chan1 <= 0;  // Reset done signal
            end
            
            if (enable_chan2 && req_chan2) begin
                done_chan2 <= 1;  // Data transfer done for channel 2
            end else begin
                done_chan2 <= 0;  // Reset done signal
            end
        end
    end
endmodule