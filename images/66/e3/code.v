module top_module(in1,in2,flag,out);input [0:63]in1,in2;
    input flag;
    output [0:63]out;
    assign out=(flag==1'b1)?in1:in2;
endmodule