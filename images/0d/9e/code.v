module ARQ_Sender(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg data_out,
    output reg ack_out,
    input wire nack_in
);
    reg [1:0] state;
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 0;
            ack_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        data_out <= data_in;
                        state <= SEND;
                    end
                end
                SEND: begin
                    ack_out <= 1; // Assume data is sent and we wait for ACK
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (nack_in) begin
                        // NACK received, resend data
                        state <= SEND;
                    end else begin
                        // ACK received
                        ack_out <= 0; // Clear ACK signal
                        state <= IDLE; // Go back to IDLE
                    end
                end
            endcase
        end
    end
endmodule