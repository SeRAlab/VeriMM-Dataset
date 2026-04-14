module top_module(A, B, SUM, CO);parameter  WIDTH = 8;
    input   [WIDTH-1:0] A;
    input   [WIDTH-1:0] B;
    output  [WIDTH-1:0] SUM;
    output              CO;
    wire    [WIDTH:0]   tmp;

    assign tmp = A + B;
    assign SUM = tmp [WIDTH-1:0];
    assign CO  = tmp [WIDTH];

endmodule