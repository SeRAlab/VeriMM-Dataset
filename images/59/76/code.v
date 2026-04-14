module top_module(input[13:0] a, output[1:0] s);assign s = (a==14'b0)? 2'b00 : { a[13],1'b1 };
endmodule