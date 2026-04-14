module top_module(
    input [3:0] data,
    input [1:0] sel,
    output reg out
);wire n_sel0, n_sel1, n_data0, n_data1, n_data2, n_data3;

    // NAND gates for negating select inputs
    nand(n_sel0, sel[0], sel[0]);
    nand(n_sel1, sel[1], sel[1]);

    // NAND gates for negating data inputs
    nand(n_data0, data[0], data[0]);
    nand(n_data1, data[1], data[1]);
    nand(n_data2, data[2], data[2]);
    nand(n_data3, data[3], data[3]);

    // NAND gates for implementing the 4:1 multiplexer
    wire n_sel0_n_data0, n_sel0_data1, sel0_n_data2, sel0_sel1_n_data3;
    nand(n_sel0_n_data0, n_sel0, n_data0);
    nand(n_sel0_data1, n_sel0, data[1]);
    nand(sel0_n_data2, sel[0], n_data2);
    nand(sel0_sel1_n_data3, sel[0], sel[1], n_data3);

    // NAND gate for output
    nand(out, n_sel1, n_sel0_n_data0, n_sel0_data1, sel0_n_data2, sel0_sel1_n_data3);
endmodule