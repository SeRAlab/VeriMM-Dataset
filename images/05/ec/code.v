module sliding_window_protocol (
    input wire clk,
    input wire rst,
    input wire send_enable,
    input wire [3:0] ack_id, // Acknowledgment ID from the receiver
    output reg [3:0] packet_id, // Current packet ID being sent
    output reg send_valid, // Signal to send packet
    output reg [3:0] state // State of the sender
);
    parameter WINDOW_SIZE = 4;
    reg [3:0] next_packet_id;
    reg [3:0] last_acked_id;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packet_id <= 0;
            send_valid <= 0;
            state <= 0;
            last_acked_id <= 0;
        end else begin
            case (state)
                0: begin // Idle
                    if (send_enable) begin
                        if (packet_id < (last_acked_id + WINDOW_SIZE)) begin
                            send_valid <= 1; // Ready to send
                            next_packet_id <= packet_id + 1;
                            state <= 1; // Move to sending state
                        end
                    end
                end
                1: begin // Sending
                    packet_id <= next_packet_id;
                    send_valid <= 1;
                    if (packet_id == ack_id) begin // Acknowledgment received
                        last_acked_id <= ack_id;
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule