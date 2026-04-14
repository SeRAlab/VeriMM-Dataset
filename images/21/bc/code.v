module sliding_window_protocol #(parameter WINDOW_SIZE = 4, TOTAL_FRAMES = 8) (
    input clk,
    input reset,
    input send,
    output reg [3:0] sent_frame,
    output reg [3:0] ack_frame,
    output reg window_full,
    output reg all_sent
);

reg [2:0] current_frame;
reg [2:0] frame_to_send;
reg [2:0] ack_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_frame <= 0;
        frame_to_send <= 0;
        ack_count <= 0;
        sent_frame <= 0;
        ack_frame <= 0;
        window_full <= 0;
        all_sent <= 0;
    end else begin
        if (send && !window_full) begin
            sent_frame <= frame_to_send;
            frame_to_send <= (frame_to_send + 1) % TOTAL_FRAMES;
            current_frame <= (current_frame + 1) % WINDOW_SIZE;
            if (current_frame == WINDOW_SIZE - 1) 
                window_full <= 1;
        end

        if (ack_count < WINDOW_SIZE) begin
            ack_frame <= sent_frame;
            ack_count <= ack_count + 1;
            window_full <= 0;
        end
        
        if (ack_count == TOTAL_FRAMES) 
            all_sent <= 1;
    end
end

endmodule