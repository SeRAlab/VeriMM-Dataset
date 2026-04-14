module SlidingWindowProtocol (
    input wire clk,
    input wire reset,
    input wire send_frame,
    input wire [3:0] frame_number,
    input wire ack_received,
    output reg [3:0] sent_frame,
    output reg [3:0] acked_frame,
    output reg is_window_full
);
    parameter MAX_WINDOW_SIZE = 4;
    reg [3:0] window_start;
    reg [3:0] window_end;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_start <= 0;
            window_end <= 0;
            sent_frame <= 0;
            acked_frame <= 0;
            is_window_full <= 0;
        end else begin
            if (send_frame && (window_end - window_start < MAX_WINDOW_SIZE)) begin
                sent_frame <= frame_number;
                window_end <= window_end + 1;
                if (window_end - window_start == MAX_WINDOW_SIZE - 1) begin
                    is_window_full <= 1;
                end
            end

            if (ack_received && acked_frame < sent_frame) begin
                acked_frame <= acked_frame + 1;
                window_start <= window_start + 1;
                is_window_full <= 0;
            end
        end
    end
endmodule