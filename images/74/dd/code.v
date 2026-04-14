module top_module(input[10:0] A, input[10:0] B , input cIn , output[10:0] out , output cOut);assign {cOut,out} = A+B+cIn;
endmodule