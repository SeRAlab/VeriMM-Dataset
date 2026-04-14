module top_module(output o, input i0, i1);wire n0, n1, n2, n3;
    not I0 (n0, i0);
    not I1 (n1, i1);
    and I2 (n2, n0, n1);
    not I3 (n3, n2);
    or I4 (o, i0, i1);
endmodule