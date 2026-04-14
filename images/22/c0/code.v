module viterbi_decoder (
    input clk,
    input reset,
    input input_bit,
    output reg [1:0] output_bits
);
    reg state; // 1-bit state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            output_bits <= 2'b00;
        end else begin
            case (state)
                0: begin
                    if (input_bit) begin
                        output_bits <= 2'b11; // transition for input 1
                        state <= 1;
                    end else begin
                        output_bits <= 2'b00; // transition for input 0
                        state <= 0;
                    end
                end
                1: begin
                    if (input_bit) begin
                        output_bits <= 2'b10; // transition for input 1
                        state <= 0;
                    end else begin
                        output_bits <= 2'b01; // transition for input 0
                        state <= 1;
                    end
                end
            endcase
        end
    end
endmodule