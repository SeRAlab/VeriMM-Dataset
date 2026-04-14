module sliding_window_protocol(
    input clk,
    input rst,
    input send_packet,
    input ack,
    output reg [3:0] sender_window,
    output reg [3:0] receiver_window,
    output reg [3:0] sent_packets,
    output reg [3:0] acknowledged_packets
);
    parameter WINDOW_SIZE = 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sender_window <= 0;
            receiver_window <= 0;
            sent_packets <= 0;
            acknowledged_packets <= 0;
        end else begin
            if (send_packet && (sender_window < WINDOW_SIZE)) begin
                sender_window <= sender_window + 1;
                sent_packets <= sent_packets + 1;
            end
            if (ack && (acknowledged_packets < sent_packets)) begin
                receiver_window <= receiver_window + 1;
                acknowledged_packets <= acknowledged_packets + 1;
            end
        end
    end
endmodule