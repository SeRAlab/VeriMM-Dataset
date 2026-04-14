module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [3:0] window_size,
    output reg [3:0] sent_packets,
    output reg [3:0] acked_packets
);
    parameter MAX_WINDOW_SIZE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_size <= 4'b0001; // Initial window size
            sent_packets <= 4'b0000; // No packets sent
            acked_packets <= 4'b0000; // No packets acknowledged
        end else begin
            if (send_packet && (sent_packets - acked_packets < window_size)) begin
                sent_packets <= sent_packets + 1; // Send a new packet
            end
            if (ack_received && acked_packets < sent_packets) begin
                acked_packets <= acked_packets + 1; // Acknowledge a packet
            end
        end
    end
endmodule