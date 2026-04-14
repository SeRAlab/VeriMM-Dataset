module top_module(
    input  RS,
    input RT,
    input lti,
    output lto
    );assign lto = (RT & ~RS) | (~(RS ^ RT) & lti);
endmodule