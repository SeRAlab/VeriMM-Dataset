module sliding_window_controller (
    input clk,
    input rst,
    input send_req,
    input ack,
    output reg [3:0] window,
    output reg [3:0] sent_frames,
    output reg [3:0] acked_frames
);
    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window <= 0;
            sent_frames <= 0;
            acked_frames <= 0;
        end else begin
            if (send_req && (window < WINDOW_SIZE)) begin
                sent_frames <= sent_frames + 1;
                window <= window + 1;
            end
            
            if (ack && (acked_frames < sent_frames)) begin
                acked_frames <= acked_frames + 1;
                window <= window - 1;
            end
        end
    end
endmodule