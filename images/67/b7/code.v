module top_module(
    input sw6_a1,
    input sw5_a0,
    input sw4_d4,
    input sw3_d3,
    input sw2_d2,
    input sw1_d1,
    output led8_out
    );assign led8_out = sw1_d1 & (!sw6_a1) & (!sw5_a0) | sw2_d2 & (!sw6_a1) & (sw5_a0) | sw3_d3 & (sw6_a1) & (!sw5_a0) | sw4_d4 & (sw6_a1) & (sw5_a0);


endmodule