module arq_system (
    input clk,
    input rst,
    input [4:0] data_in,
    input error,
    output reg [4:0] data_out,
    output reg ack
);
    reg [1:0] state; // 0: idle, 1: send, 2: wait, 3: ack

    parameter IDLE = 2'b00, SEND = 2'b01, WAIT = 2'b10, ACK = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 5'b0;
            ack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= SEND;
                end
                SEND: begin
                    data_out <= data_in; // Send data
                    state <= WAIT;
                end
                WAIT: begin
                    if (error) begin
                        ack <= 0; // NACK
                        state <= SEND; // Resend data
                    end else begin
                        ack <= 1; // ACK
                        state <= ACK;
                    end
                end
                ACK: begin
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule