module sliding_window_protocol (
    input clk,
    input rst,
    input send_packet,
    input ack,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg [3:0] sent_packets
);
    parameter N = 4; // Window size
    initial begin
        window_start = 0;
        window_end = 0;
        sent_packets = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_start <= 0;
            window_end <= 0;
            sent_packets <= 0;
        end else begin
            if (send_packet && (window_end - window_start < N)) begin
                sent_packets <= sent_packets + 1;
                window_end <= window_end + 1;
            end
            if (ack && (window_start < window_end)) begin
                window_start <= window_start + 1;
            end
        end
    end
endmodule