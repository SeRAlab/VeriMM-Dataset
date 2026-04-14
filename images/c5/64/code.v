module multi_input_module (
    input a,
    input b,
    input c,
    input d,
    input e,
    input f,
    input g,
    input h,
    input i,
    output out
);

    wire ab_high;
    wire cd_high;
    wire ef_low;
    wire g_high;
    wire h_low;
    wire i_high;

    assign ab_high = a & b;
    assign cd_high = c | d;
    assign ef_low = ~(e | f);
    assign g_high = g;
    assign h_low = ~h;
    assign i_high = i;

    assign out = ab_high | cd_high | ef_low | g_high | h_low | i_high;

endmodule