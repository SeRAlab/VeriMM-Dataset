module ARQ (
    input clk,
    input reset,
    input send_data,
    input ack,
    output reg resend_data,
    output reg sent_data
);
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter SEND = 2'b01;
    parameter WAIT_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sent_data <= 0;
            resend_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        sent_data <= 1;
                        resend_data <= 0;
                        state <= SEND;
                    end
                end
                SEND: begin
                    if (ack) begin
                        sent_data <= 0; // Data received correctly
                        state <= IDLE;
                    end else begin
                        resend_data <= 1; // Data not received correctly
                        state <= WAIT_ACK;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        sent_data <= 0; // Data received correctly
                        state <= IDLE;
                    end else begin
                        resend_data <= 1; // Continue to resend
                    end
                end
            endcase
        end
    end
endmodule