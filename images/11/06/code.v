module sliding_window_protocol (
    input clk,
    input reset,
    input send_frame,
    input ack,
    output reg [3:0] sent_frames,
    output reg [3:0] acknowledged_frames,
    output reg window_full,
    output reg window_empty
);
    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sent_frames <= 0;
            acknowledged_frames <= 0;
            window_full <= 0;
            window_empty <= 1;
        end else begin
            if (send_frame && !window_full) begin
                sent_frames <= sent_frames + 1;
                acknowledged_frames <= acknowledged_frames; // Remain unchanged until ACK
            end
            
            if (ack && acknowledged_frames < sent_frames) begin
                acknowledged_frames <= acknowledged_frames + 1;
            end
            
            // Update window status
            if (sent_frames - acknowledged_frames >= WINDOW_SIZE) begin
                window_full <= 1;
            end else begin
                window_full <= 0;
            end
            
            if (acknowledged_frames == sent_frames) begin
                window_empty <= 1;
            end else begin
                window_empty <= 0;
            end
        end
    end
endmodule