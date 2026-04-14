module sliding_window_protocol(
    input clk,
    input rst,
    input send,
    input ack,
    output reg [3:0] sent_frames,
    output reg [3:0] acknowledged_frames
);
    parameter WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_frames <= 0;
            acknowledged_frames <= 0;
        end else begin
            if (send && (sent_frames - acknowledged_frames < WINDOW_SIZE)) begin
                sent_frames <= sent_frames + 1;
            end
            if (ack && (acknowledged_frames < sent_frames)) begin
                acknowledged_frames <= acknowledged_frames + 1;
            end
        end
    end
endmodule