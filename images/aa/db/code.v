module top_module(input A,input B,input C,output  add,output  out_c);assign add = (A ^ B) ^ C;
assign out_c=(A ^ B) | (A & C) | (C & B);endmodule