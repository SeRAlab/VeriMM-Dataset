module ARQ_Protocol (
    input clk,
    input rst,
    input data_in,
    input ack,
    output reg data_out,
    output reg retransmit,
    output reg error
);
    reg [1:0] state;
    parameter IDLE = 2'b00, WAIT_ACK = 2'b01, RETRANSMIT = 2'b10, ERROR_STATE = 2'b11;

    initial begin
        data_out = 0;
        retransmit = 0;
        error = 0;
        state = IDLE;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            retransmit <= 0;
            error <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= data_in; // Send data
                    retransmit <= 0;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE; // Data received correctly
                    end else begin
                        if (retransmit < 3) begin
                            retransmit <= retransmit + 1; // Increment retransmission count
                            state <= RETRANSMIT;
                        end else begin
                            error <= 1; // Max retries reached, set error
                            state <= ERROR_STATE;
                        end
                    end
                end
                RETRANSMIT: begin
                    data_out <= data_in; // Retransmit data
                    state <= WAIT_ACK;
                end
                ERROR_STATE: begin
                    // Handle error (could reset or alert)
                    // Just stay in error state for simplicity
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule