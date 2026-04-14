module top_module(in1,in2,sel,out);input [31:0] in1,in2;
    input sel;
    output [31:0] out;

    assign out = (sel == 0) ? in1 : in2;
endmodule