module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter PACKET_SIZE = 8) (
    input clk,
    input rst,
    input send_packet,
    input ack,
    output reg [PACKET_SIZE-1:0] packet_out,
    output reg valid_out
);
    reg [1:0] state; // 00: IDLE, 01: SENDING, 10: WAITING_ACK
    reg [3:0] sent_count; // Number of packets sent

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            sent_count <= 0;
            packet_out <= 0;
            valid_out <= 0;
        end else begin
            case (state)
                0: begin // IDLE
                    valid_out <= 0;
                    if (send_packet && sent_count < WINDOW_SIZE) begin
                        packet_out <= sent_count; // Sending packet with count
                        valid_out <= 1;
                        sent_count <= sent_count + 1;
                        state <= 1; // Move to SENDING state
                    end
                end
                1: begin // SENDING
                    if (ack) begin
                        state <= 0; // Move back to IDLE on ACK
                    end
                end
            endcase
        end
    end
endmodule