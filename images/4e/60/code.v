module top_module(output D,B,input x,y);assign B=((!x)&&y);
assign D=(((!x)&&y)||((!y)&&x));

endmodule