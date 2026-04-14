module sliding_window_protocol #(parameter N = 4) (
    input clk,
    input rst,
    input send,          // signal to send a frame
    input ack,           // acknowledgment from receiver
    output reg [N-1:0] sent_frames, // bit vector indicating sent frames
    output reg [N-1:0] ack_frames  // bit vector indicating acknowledged frames
);

    reg [1:0] state; // 0: idle, 1: sending, 2: waiting for ack
    reg [N-1:0] frame_counter;

    initial begin
        sent_frames = 0;
        ack_frames = 0;
        frame_counter = 0;
        state = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_frames <= 0;
            ack_frames <= 0;
            frame_counter <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (send) begin
                        sent_frames[frame_counter] <= 1; // mark frame as sent
                        frame_counter <= frame_counter + 1;
                        if (frame_counter >= N) 
                            frame_counter <= 0; // wrap around
                        state <= 1; // move to sending state
                    end
                end
                1: begin // sending state
                    if (ack) begin
                        ack_frames[frame_counter] <= 1; // ack the sent frame
                        state <= 0; // go back to idle
                    end
                end
            endcase
        end
    end
endmodule