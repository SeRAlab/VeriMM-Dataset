module top_module(x,y,s);input [7:0]  x,y;
    output[7:0]  s;

    assign s = x + y;

endmodule