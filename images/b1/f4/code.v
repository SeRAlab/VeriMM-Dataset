module top_module(output o, input i0, i1, i2, i3);wire and1_out, and2_out;

    and and1(and1_out, i0, i1);
    and and2(and2_out, i2, i3);
    or or1(o, and1_out, and2_out);
endmodule