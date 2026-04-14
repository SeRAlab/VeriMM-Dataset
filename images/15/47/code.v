module sliding_window_protocol (
    input wire clk,
    input wire reset,
    input wire send,
    input wire ack,
    output reg [3:0] window_size,
    output reg [3:0] sent_frames,
    output reg [3:0] received_frames
);

parameter MAX_WINDOW_SIZE = 4'd4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        window_size <= 4'd0;
        sent_frames <= 4'd0;
        received_frames <= 4'd0;
    end else begin
        if (send && window_size < MAX_WINDOW_SIZE) begin
            sent_frames <= sent_frames + 1;
            window_size <= window_size + 1;
        end
        if (ack && window_size > 0) begin
            received_frames <= received_frames + 1;
            window_size <= window_size - 1;
        end
    end
end

endmodule