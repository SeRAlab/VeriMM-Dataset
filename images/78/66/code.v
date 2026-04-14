module top_module(
    input [1:0] a,
    input [1:0] b,
    output out
);wire n1, n2, n3, n4, n5;

assign n1 = ~(a[1] & b[1]);
assign n2 = ~(a[1] & b[0]);
assign n3 = ~(a[0] & b[1]);
assign n4 = ~(a[0] & b[0]);
assign n5 = ~(n1 & n2 & n3 & n4);

assign out = n5;

endmodule