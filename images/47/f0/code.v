module top_module(a,b,y);input a,b;						output [1:0] y;

    assign y[0]=a | b;
    assign y[1]=a & b;endmodule