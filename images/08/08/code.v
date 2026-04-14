module ARQ_Controller(
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg ack_out,
    output reg request_retransmit
);
    reg [1:0] state;
    parameter IDLE = 2'b00, RECEIVING = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack_out <= 0;
            request_retransmit <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_out <= data_in; // Receive data
                        state <= RECEIVING;
                        ack_out <= 1; // Acknowledge receipt
                    end
                end
                RECEIVING: begin
                    if (data_in[7] == 1'b0) // Assume LSB indicates error
                        state <= IDLE; // No error, go back to IDLE
                    else
                        state <= ERROR; // Error detected
                end
                ERROR: begin
                    request_retransmit <= 1; // Request retransmission
                    if (valid_in) begin
                        state <= IDLE; // Go back to IDLE after retransmit request
                    end
                end
            endcase
        end
    end
endmodule