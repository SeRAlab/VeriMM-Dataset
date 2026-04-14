module top_module(sel, din0, din1, dout);parameter width = 1;
    input sel;
    input [width-1:0] din0;
    input [width-1:0] din1;
    output [width-1:0] dout;
    
    assign dout = (0 == sel) ? din0 : din1;
endmodule