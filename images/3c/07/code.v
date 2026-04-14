module sliding_window_protocol (
    input clk,
    input reset,
    input send_frame,
    input ack_frame,
    output reg [3:0] sent_frames,
    output reg [3:0] acked_frames,
    output reg window_full,
    output reg window_empty
);
    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_frames <= 0;
            acked_frames <= 0;
            window_full <= 0;
            window_empty <= 1;
        end else begin
            if (send_frame && !window_full) begin
                sent_frames <= sent_frames + 1;
                if (sent_frames + 1 >= WINDOW_SIZE) begin
                    window_full <= 1;
                end
                window_empty <= 0;
            end
            
            if (ack_frame && !window_empty) begin
                acked_frames <= acked_frames + 1;
                if (acked_frames + 1 >= WINDOW_SIZE) begin
                    window_empty <= 1;
                end
                window_full <= 0;
            end
        end
    end
endmodule