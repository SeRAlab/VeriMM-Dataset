module sliding_window_protocol (
    input clk,
    input reset,
    input send_frame,
    input recv_ack,
    output reg [3:0] frames_sent,
    output reg [3:0] frames_acknowledged,
    output reg window_full
);
    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frames_sent <= 0;
            frames_acknowledged <= 0;
            window_full <= 0;
        end else begin
            if (recv_ack && frames_acknowledged < frames_sent) begin
                frames_acknowledged <= frames_acknowledged + 1;
            end
            
            if (send_frame && (frames_sent - frames_acknowledged < WINDOW_SIZE)) begin
                frames_sent <= frames_sent + 1;
            end
            
            if (frames_sent - frames_acknowledged >= WINDOW_SIZE) begin
                window_full <= 1;
            end else begin
                window_full <= 0;
            end
        end
    end
endmodule