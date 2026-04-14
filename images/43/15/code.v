module top_module(input A,input B,input carryin,output sum,output carryout);assign sum = (A ^ B ^ carryin);
 assign carryout = ((A ^ B) & carryin)|(A & B);endmodule