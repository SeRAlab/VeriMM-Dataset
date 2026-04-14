module dma_controller (
    input clk,
    input reset,
    input start_channel1,
    input start_channel2,
    input channel1_done,
    input channel2_done,
    output reg active_channel1,
    output reg active_channel2
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_channel1 <= 0;
            active_channel2 <= 0;
        end else begin
            if (start_channel1 && !active_channel1) begin
                active_channel1 <= 1;
            end else if (channel1_done && active_channel1) begin
                active_channel1 <= 0;
            end
            
            if (start_channel2 && !active_channel2) begin
                active_channel2 <= 1;
            end else if (channel2_done && active_channel2) begin
                active_channel2 <= 0;
            end
        end
    end
endmodule