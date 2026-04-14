module top_module(
    input e0,
    input e1,
    output s0,
    output s1,
    output s2,
    output s3,
    output s4,
    output s5,
    output s6,
    output s7
);assign s0 = e0 & e1;

assign s1 = e0 | e1;

assign s2 = e0 ^ e1;

assign s3 = ~(e0 & e1);

assign s4 = ~(e0 | e1);

assign s5 = ~(e0 ^ e1);

assign s6 = ~e0;

assign s7 = e0;


endmodule