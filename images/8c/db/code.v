module top_module(
    input [3:0] binary_input,
    output [3:0] gray_output
);assign gray_output = {binary_input[3], binary_input[3]^binary_input[2], binary_input[2]^binary_input[1], binary_input[1]^binary_input[0]};
    
endmodule