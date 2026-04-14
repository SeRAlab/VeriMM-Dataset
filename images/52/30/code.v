module top_module(
    input [3:0] binary_input,
    output reg [3:0] gray_output
);always @(*) begin
        gray_output[0] = binary_input[0];
        gray_output[1] = binary_input[0] ^ binary_input[1];
        gray_output[2] = binary_input[1] ^ binary_input[2];
        gray_output[3] = binary_input[2] ^ binary_input[3];
    end

endmodule