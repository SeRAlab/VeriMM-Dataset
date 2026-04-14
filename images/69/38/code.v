module top_module(
    input a, b,
    output cout, sum );wire mux_out;

    assign mux_out = a ^ b;

    assign sum = mux_out;

    assign cout = a & b;

endmodule