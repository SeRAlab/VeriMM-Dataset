module stop_and_wait (
    input clk,
    input reset,
    input send,
    input ack,
    input timeout,
    output reg [7:0] packet_out,
    output reg ack_out,
    output reg retransmit
);

    reg [7:0] last_packet;
    reg state; // 0 -> Idle, 1 -> Sending

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            packet_out <= 0;
            ack_out <= 0;
            retransmit <= 0;
            last_packet <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    ack_out <= 0;
                    retransmit <= 0;
                    if (send) begin
                        last_packet <= last_packet + 1; // New packet
                        packet_out <= last_packet;
                        state <= 1; // Move to sending state
                    end
                end
                1: begin // Sending state
                    if (ack) begin
                        ack_out <= 1; // Received ACK
                        state <= 0; // Go back to idle
                    end else if (timeout) begin
                        retransmit <= 1; // Prepare to retransmit
                        packet_out <= last_packet; // Retransmit last packet
                    end
                end
            endcase
        end
    end
endmodule