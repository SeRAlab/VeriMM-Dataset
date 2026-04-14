module top_module(input x,y, cin, output cout, s);assign s=(x & y)|(y & cin)|(cin & x);
assign cout =x ^y ^ cin;
endmodule