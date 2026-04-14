module top_module(
    input [3:0] num_in,
    output [3:0] num_out
);wire [3:0] inverted_num;
    wire [3:0] one = 4'b0001;
    
    assign inverted_num = ~num_in;
    assign num_out = inverted_num + one;
    
endmodule