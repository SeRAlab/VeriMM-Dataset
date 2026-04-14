module top_module(addOut, in1, in2);output [7:0] addOut;
    input [7:0] in1;
    input [7:0] in2;
    
    assign addOut = in1 + in2;endmodule