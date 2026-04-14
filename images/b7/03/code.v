module top_module(C, S, cout, cin, w, x, y, z);output C;
    output S;
    output cout;
    input cin;
    input w;
    input x;
    input y;
    input z;

wire temp1;
assign temp1 = w ^ x ^ y ^ z;

assign C = (temp1 & cin) | (~temp1 & ((w & x) | (y & z)));
assign S =  w ^ x ^ y ^ z ^ cin;
assign cout = (w | x) & (y | z);

endmodule