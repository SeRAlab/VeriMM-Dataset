module sliding_window_protocol (
    input clk,
    input reset,
    input send_frame,
    input ack_frame,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg frame_sent,
    output reg frame_acknowledged
);
    parameter WINDOW_SIZE = 4;
    reg [3:0] current_frame;
    reg [1:0] state; // 0: idle, 1: sending, 2: waiting for ack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_start <= 0;
            window_end <= WINDOW_SIZE - 1;
            current_frame <= 0;
            state <= 0;
            frame_sent <= 0;
            frame_acknowledged <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (send_frame && (window_end < 16)) begin
                        frame_sent <= 1;
                        current_frame <= window_start;
                        state <= 1;
                    end
                end
                1: begin // sending state
                    frame_sent <= 0;
                    window_start <= window_start + 1;
                    window_end <= window_end + 1;
                    state <= 2;
                end
                2: begin // waiting for ack
                    if (ack_frame) begin
                        frame_acknowledged <= 1;
                        state <= 0;
                    end else begin
                        frame_acknowledged <= 0;
                    end
                end
            endcase
        end
    end
endmodule