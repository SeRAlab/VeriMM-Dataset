module dma_controller(
    input clk,
    input req_ch1,
    input req_ch2,
    output reg done_ch1,
    output reg done_ch2,
    output reg [7:0] data
);

    reg active_channel; // 0 for channel 1, 1 for channel 2

    always @(posedge clk) begin
        if (req_ch1 && !active_channel) begin
            active_channel <= 0; // Grant channel 1
            data <= 8'hAA; // Example data
            done_ch1 <= 1'b1;
            done_ch2 <= 1'b0;
        end
        else if (req_ch2 && active_channel) begin
            active_channel <= 1; // Grant channel 2
            data <= 8'hBB; // Example data
            done_ch1 <= 1'b0;
            done_ch2 <= 1'b1;
        end
        else begin
            done_ch1 <= 1'b0;
            done_ch2 <= 1'b0;
        end
    end

endmodule