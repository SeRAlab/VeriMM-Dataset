module ARQ (
    input clk,
    input rst,
    input [4:0] data_in,
    input recv_ack,
    output reg [4:0] data_out,
    output reg resend,
    output reg [1:0] resend_count
);
    reg [1:0] state;
    localparam IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            resend_count <= 2'b00;
            resend <= 1'b0;
            data_out <= 5'b00000;
        end else begin
            case (state)
                IDLE: begin
                    if (resend_count < 2'b11) begin
                        data_out <= data_in;
                        resend <= 1'b0;
                        state <= SEND;
                    end else begin
                        state <= IDLE; // Stop sending after 3 attempts
                    end
                end
                SEND: begin
                    resend <= 1'b1;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (recv_ack) begin
                        resend_count <= 2'b00; // Reset counter if acknowledged
                        state <= IDLE;
                    end else begin
                        resend_count <= resend_count + 1; // Increment resend count
                        state <= IDLE; // Go back to IDLE
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule