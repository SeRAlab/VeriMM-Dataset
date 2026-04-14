module sliding_window_protocol(
    input wire clk,
    input wire reset,
    input wire send_frame,
    input wire ack,
    input wire timeout,
    output reg frame_sent,
    output reg frame_ack
);
    reg [1:0] window_size; // 00 = 0 frames, 01 = 1 frame, 10 = 2 frames, 11 = 3 frames
    reg [3:0] next_frame;
    reg [3:0] acked_frame;

    initial begin
        window_size = 2'b00;
        next_frame = 4'b0000;
        acked_frame = 4'b0000;
        frame_sent = 0;
        frame_ack = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_size <= 2'b00;
            next_frame <= 4'b0000;
            acked_frame <= 4'b0000;
            frame_sent <= 0;
            frame_ack <= 0;
        end else begin
            if (send_frame && window_size < 2'b11) begin
                frame_sent <= 1;
                next_frame <= next_frame + 1;
                window_size <= window_size + 1;
            end else begin
                frame_sent <= 0;
            end

            if (ack) begin
                frame_ack <= 1;
                acked_frame <= acked_frame + 1;
                window_size <= window_size - 1;
            end else begin
                frame_ack <= 0;
            end
            
            if (timeout) begin
                // Simulate timeout handling, reset the window
                window_size <= 2'b00;
                next_frame <= 4'b0000;
            end
        end
    end
endmodule