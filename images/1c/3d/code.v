module stop_and_wait_arq (
    input wire clk,
    input wire rst,
    input wire data_in, // Data to be sent (1 bit)
    input wire ack, // Acknowledgment signal from receiver
    output reg data_out, // Data sent (1 bit)
    output reg parity_out, // Parity bit
    output reg retransmit // Signal to indicate retransmission needed
);
    
    reg [1:0] state; // State of the FSM
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 0;
            parity_out <= 0;
            retransmit <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Prepare to send data
                    data_out <= data_in;
                    parity_out <= data_in ^ 1'b1; // Calculate parity
                    retransmit <= 0;
                    state <= SEND;
                end
                SEND: begin
                    // Wait for ACK/NACK
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) begin
                        // Acknowledgement received, go back to IDLE
                        retransmit <= 0;
                        state <= IDLE;
                    end else begin
                        // NACK received, retransmit data
                        retransmit <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule