module sliding_window_protocol(
    input clk,
    input reset,
    input [3:0] window_size, // Acceptable window size
    input send_packet, // Signal to send a packet
    output reg [3:0] sent_count, // Count of packets sent
    output reg [3:0] ack_count // Count of acknowledged packets
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sent_count <= 0;
        ack_count <= 0;
    end else begin
        if (send_packet && (sent_count - ack_count < window_size)) begin
            sent_count <= sent_count + 1;
        end
        // Simulate an acknowledgment for every packet sent
        if (sent_count > ack_count) begin
            ack_count <= ack_count + 1;
        end
    end
end

endmodule