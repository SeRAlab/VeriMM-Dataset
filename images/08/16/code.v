module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter FRAME_COUNT = 16) (
    input wire clk,
    input wire rst,
    input wire send,
    input wire [3:0] ack, // Acknowledgment for frames
    output reg [3:0] current_frame, // Frame being sent
    output reg [3:0] window_start,
    output reg [3:0] window_end
);
    reg [3:0] sent_frames [0:FRAME_COUNT-1];
    reg [3:0] next_frame;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_frame <= 0;
            window_start <= 0;
            window_end <= WINDOW_SIZE - 1;
            for (i = 0; i < FRAME_COUNT; i = i + 1) begin
                sent_frames[i] <= 0;
            end
        end else begin
            if (send && (next_frame < (window_start + WINDOW_SIZE))) begin
                sent_frames[next_frame] <= next_frame;
                current_frame <= next_frame;
                next_frame <= next_frame + 1;
            end
            
            // Update the window based on acknowledgment
            if (ack[window_start]) begin
                window_start <= window_start + 1;
                window_end <= window_start + WINDOW_SIZE - 1;
            end
        end
    end
endmodule