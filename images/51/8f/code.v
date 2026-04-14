module top_module(
    input a,
    input b,
    input c,
    input d,
    input e,
    input f,
    input g,
    input h,
    output out
);wire ab = a & b;
    wire cd = c & d;
    wire ef = e & f;
    wire gh = g & h;

    assign out = (ab | cd | ef | gh);

endmodule