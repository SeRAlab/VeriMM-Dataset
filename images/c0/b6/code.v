module f3_sub1(a, c);
    input [1:0] a;
    output [1:0] c;
    assign c[0] = (~a[0]) & a[1];
    assign c[1] = (~a[0]) & (~a[1]);
endmodule