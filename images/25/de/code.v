module arq_system (
    input wire clk,
    input wire rst,
    input wire data_in,
    input wire ack,
    input wire nack,
    output reg data_out,
    output reg err,
    output reg ack_out
);

    reg [1:0] state;
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 0;
            err <= 0;
            ack_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= data_in; // Load data to send
                    ack_out <= 0; // Reset ACK output
                    state <= SEND;
                end
                SEND: begin
                    ack_out <= 1; // Send data and wait for ACK
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) begin
                        ack_out <= 0; // Clear ACK output
                        state <= IDLE; // Go back to IDLE to send next data
                    end else if (nack) begin
                        err <= 1; // Set error flag on NACK
                        state <= SEND; // Retransmit data
                    end
                end
            endcase
        end
    end

endmodule