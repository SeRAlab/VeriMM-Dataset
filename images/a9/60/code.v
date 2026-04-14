module top_module(x,y,cin,cout,s);input x, y, cin;
output s, cout;

assign {cout,s} = x+y+cin;endmodule