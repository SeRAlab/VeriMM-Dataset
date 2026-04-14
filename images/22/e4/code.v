module dma_controller (
    input wire req1,
    input wire req2,
    input wire clk,
    input wire reset,
    output reg ack1,
    output reg ack2,
    output reg active_channel
);
    reg state; // 0 for channel 1, 1 for channel 2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack1 <= 0;
            ack2 <= 0;
            active_channel <= 0;
            state <= 0;
        end else begin
            ack1 <= 0;
            ack2 <= 0;
            if (req1 && !req2) begin
                state <= 0;
                ack1 <= 1;
                active_channel <= 0;
            end else if (!req1 && req2) begin
                state <= 1;
                ack2 <= 1;
                active_channel <= 1;
            end else if (req1 && req2) begin
                state <= 0; // priority to channel 1
                ack1 <= 1;
                active_channel <= 0;
            end
        end
    end
endmodule