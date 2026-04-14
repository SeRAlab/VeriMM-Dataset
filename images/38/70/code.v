module sliding_window_protocol(
    input clk,
    input reset,
    input ack,
    output reg [3:0] sent_packets,
    output reg window_full
);
    parameter WINDOW_SIZE = 4; // Fixed window size

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_packets <= 0;
            window_full <= 0;
        end else if (ack) begin
            if (sent_packets > 0) begin
                sent_packets <= sent_packets - 1;
                window_full <= 0;
            end
        end else if (sent_packets < WINDOW_SIZE) begin
            sent_packets <= sent_packets + 1;
            if (sent_packets == WINDOW_SIZE - 1) begin
                window_full <= 1;
            end
        end
    end
endmodule