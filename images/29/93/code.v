module sliding_window_protocol(
    input clk,
    input reset,
    input send_frame,
    input ack,
    output reg [3:0] sent_frames,
    output reg [3:0] acked_frames,
    output reg [3:0] window_start,
    output reg [3:0] window_end
);

parameter WINDOW_SIZE = 4;
reg [3:0] next_sent_frames;
reg [3:0] next_acked_frames;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sent_frames <= 4'b0000;
        acked_frames <= 4'b0000;
        window_start <= 4'b0000;
        window_end <= 4'b0000;
    end else begin
        if (send_frame && (window_end - window_start < WINDOW_SIZE)) begin
            next_sent_frames <= sent_frames + 1;
            window_end <= window_end + 1;
        end

        if (ack) begin
            next_acked_frames <= acked_frames + 1;
            window_start <= window_start + 1;
        end

        sent_frames <= next_sent_frames;
        acked_frames <= next_acked_frames;
    end
end
endmodule