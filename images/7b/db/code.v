module top_module(
    input A,
    input B,
    input S,
    output Y
);assign Y = S ? B : A; // Simple multiplexer behavior
endmodule