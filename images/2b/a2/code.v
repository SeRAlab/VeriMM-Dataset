module viterbi_decoder (
    input clk,
    input rst,
    input bit_in,
    output reg [1:0] decoded_out
);
    reg state; // current state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            decoded_out <= 2'b00;
        end else begin
            // State transition based on input
            case (state)
                0: begin
                    if (bit_in == 0) begin
                        decoded_out <= 2'b00; // output for state 0, input 0
                        state <= 0; // stay in state 0
                    end else begin
                        decoded_out <= 2'b01; // output for state 0, input 1
                        state <= 1; // transition to state 1
                    end
                end
                1: begin
                    if (bit_in == 0) begin
                        decoded_out <= 2'b10; // output for state 1, input 0
                        state <= 0; // transition to state 0
                    end else begin
                        decoded_out <= 2'b11; // output for state 1, input 1
                        state <= 1; // stay in state 1
                    end
                end
            endcase
        end
    end
endmodule