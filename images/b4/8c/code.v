module top_module(
    input selector,
    input in,
    input pass_through,
    output out
    );assign out = (in && selector) || pass_through;

endmodule