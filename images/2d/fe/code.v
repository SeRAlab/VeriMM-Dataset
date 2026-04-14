module viterbi_decoder (
    input clk,
    input rst,
    input [1:0] input_seq,
    output reg decoded_output
);
    reg state; // current state: 0 or 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            decoded_output <= 0;
        end else begin
            case (state)
                0: begin
                    if (input_seq == 2'b00) begin
                        state <= 0;
                        decoded_output <= 0;
                    end else if (input_seq == 2'b01) begin
                        state <= 1;
                        decoded_output <= 1;
                    end
                end
                1: begin
                    if (input_seq == 2'b10) begin
                        state <= 0;
                        decoded_output <= 0;
                    end else if (input_seq == 2'b11) begin
                        state <= 1;
                        decoded_output <= 1;
                    end
                end
            endcase
        end
    end
endmodule