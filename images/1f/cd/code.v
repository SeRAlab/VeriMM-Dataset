module sliding_window_protocol(
    input clk,
    input reset,
    input send_frame,
    input ack_frame,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg [3:0] sent_frames,
    output reg [3:0] acknowledged_frames
);

parameter WINDOW_SIZE = 4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        window_start <= 0;
        window_end <= WINDOW_SIZE - 1;
        sent_frames <= 0;
        acknowledged_frames <= 0;
    end else begin
        if (send_frame && (sent_frames < WINDOW_SIZE)) begin
            sent_frames <= sent_frames + 1;
            window_end <= window_end + 1;
        end
        
        if (ack_frame && (acknowledged_frames < sent_frames)) begin
            acknowledged_frames <= acknowledged_frames + 1;
            window_start <= window_start + 1;
        end
        
        if (acknowledged_frames == sent_frames) begin
            acknowledged_frames <= 0; // Reset acknowledged frames after all are acknowledged
            sent_frames <= 0; // Reset sent frames after acknowledgment
        end
    end
end

endmodule