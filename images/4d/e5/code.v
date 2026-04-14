module top_module(in,res);input [31:0]in;
    output [31:0]res;
    assign res={in[29:0],2'b00}; 
endmodule