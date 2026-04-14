module top_module(input A,input B,output Out);wire tmp;
assign tmp = (A==1'b0)?1'b1:(!B);
buf #(18,21) (Out, tmp);endmodule