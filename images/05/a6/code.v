module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] input_bits,
    output reg output_bit
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            output_bit <= 1'b0;
        end else begin
            state <= input_bits; // Simple transition for demonstration
            if (state == 2'b00) 
                output_bit <= 1'b0;
            else 
                output_bit <= 1'b1;
        end
    end
endmodule