module top_module(A, B, out);parameter WIDTH = 32;
    input signed[WIDTH-1:0]A, B;
    output signed[WIDTH-1:0] out;

    assign out = A + B;


endmodule