module even_parity_gen (
    input [5:0] data,
    output parity);assign parity = ^data;
endmodule