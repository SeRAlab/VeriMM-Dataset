module top_module(
    x1,
    x2,
    cin,
    s,
    c
);input x1;
input x2;
input cin;
output s;
wire s;
output c;
wire c;





assign s = ((x1 ^ x2) ^ cin);
assign c = (((x1 & x2) | (x1 & cin)) | (x2 & cin));

endmodule