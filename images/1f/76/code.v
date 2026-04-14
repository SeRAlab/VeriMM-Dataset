module stop_and_wait(
    input clk,
    input reset,
    input send_data,
    input ack_received,
    output reg data_sent,
    output reg resend_data,
    output reg [3:0] state
);

    parameter IDLE = 4'b0000,
              WAIT_ACK = 4'b0001,
              RESEND = 4'b0010,
              DATA_SENT = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_sent <= 0;
            resend_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        data_sent <= 1;
                        state <= WAIT_ACK;
                    end
                end
                WAIT_ACK: begin
                    if (ack_received) begin
                        data_sent <= 0;
                        state <= IDLE;
                    end else begin
                        state <= RESEND;
                    end
                end
                RESEND: begin
                    resend_data <= 1;
                    state <= WAIT_ACK;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule