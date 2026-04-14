module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input [1:0] ack,
    output reg [1:0] window_start,
    output reg [1:0] window_end,
    output reg [3:0] sent_packets
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_start <= 0;
            window_end <= 0;
            sent_packets <= 0;
        end else begin
            if (send_packet && (window_end - window_start < 4)) begin
                sent_packets[window_end] <= 1; // Mark packet as sent
                window_end <= window_end + 1; // Move window forward
            end
            if (ack < window_end) begin
                sent_packets[ack] <= 0; // Mark packet as acknowledged
                window_start <= window_start + 1; // Slide window
            end
        end
    end
endmodule