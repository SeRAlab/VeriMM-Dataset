module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter TOTAL_PACKETS = 10) (
    input clk,
    input rst,
    input ack, // acknowledgment signal from the receiver
    output reg [3:0] send_window, // current send window
    output reg [3:0] next_packet // packet to be sent next
);
    reg [3:0] sent_packets; // number of packets sent
    reg [3:0] acknowledged_packets; // number of packets acknowledged

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            send_window <= 0;
            next_packet <= 0;
            sent_packets <= 0;
            acknowledged_packets <= 0;
        end else begin
            // Send packets if within the window size
            if (sent_packets < (acknowledged_packets + WINDOW_SIZE) && sent_packets < TOTAL_PACKETS) begin
                next_packet <= sent_packets;
                sent_packets <= sent_packets + 1;
            end
            
            // Acknowledge received packets
            if (ack && acknowledged_packets < sent_packets) begin
                acknowledged_packets <= acknowledged_packets + 1;
            end
            
            // Update the send window
            send_window <= acknowledged_packets + WINDOW_SIZE;
        end
    end
endmodule