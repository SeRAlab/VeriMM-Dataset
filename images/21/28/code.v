module stop_and_wait (
    input clk,
    input rst,
    input recv_ack,      // Acknowledgment signal from the receiver
    output reg [2:0] packet_sent, // Current packet number sent (0 to 4)
    output reg resend,   // Signal to indicate to resend the packet
    output reg send      // Signal to send the packet
);

    parameter IDLE = 2'b00, WAIT_ACK = 2'b01, SEND = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            packet_sent <= 3'b000;
            resend <= 0;
            send <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                send = 1;
                resend = 0;
                if (packet_sent < 3'b100) // Less than 5 packets
                    next_state = SEND;
                else
                    next_state = IDLE; // Finished sending
            end

            SEND: begin
                send = 1;
                resend = 0;
                next_state = WAIT_ACK;
            end

            WAIT_ACK: begin
                send = 0;
                if (recv_ack) begin
                    packet_sent = packet_sent + 1;
                    next_state = IDLE;
                end else begin
                    resend = 1; // Need to resend the same packet
                    next_state = WAIT_ACK;
                end
            end

            default: begin
                send = 0;
                resend = 0;
                next_state = IDLE;
            end
        endcase
    end
endmodule