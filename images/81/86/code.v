module top_module(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);wire [8:0] temp_sum;
    
    assign temp_sum = {Cin, A} + {Cin, B};
    
    assign Cout = (temp_sum[8] == 1);
    
    assign Sum = temp_sum[7:0];
    
endmodule