module ARQ (
    input wire clk,
    input wire rst,
    input wire send_data,
    input wire ack_received,
    output reg retransmit,
    output reg ack_out,
    output reg [7:0] data_out
);

    reg [1:0] state;
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            retransmit <= 0;
            ack_out <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        state <= SENDING;
                        ack_out <= 1;
                        data_out <= 8'b10101010; // Example data
                    end
                end
                SENDING: begin
                    if (ack_received) begin
                        ack_out <= 0; // Reset acknowledgment output
                        state <= IDLE; // Go back to IDLE state
                    end else begin
                        retransmit <= 1; // Request retransmission
                        state <= WAIT_ACK;
                    end
                end
                WAIT_ACK: begin
                    if (ack_received) begin
                        ack_out <= 0; // Reset acknowledgment output
                        state <= IDLE; // Go back to IDLE state
                    end else begin
                        retransmit <= 1; // Keep requesting retransmission
                    end
                end
            endcase
        end
    end
endmodule