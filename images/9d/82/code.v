module top_module(A, B, SUM);parameter  WIDTH = 8;
    input signed   [WIDTH-1:0] A;
    input signed   [WIDTH-1:0] B;
    output signed  [WIDTH-1:0] SUM;

    assign SUM = A + B;

endmodule