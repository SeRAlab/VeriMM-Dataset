module top_module(
    out,
    in0,
    in1,
    sel
);output out;
    input in0;
    input in1;
    input sel;

    wire nand_out;
    wire or_out;

    // Replace sky130_fd_sc_hdll__nand2 with a behavioral NAND implementation
    assign nand_out = ~(in0 & sel);

    // Replace sky130_fd_sc_hdll__or2 with a behavioral OR implementation
    assign or_out = in1 | sel;

    // Replace sky130_fd_sc_hdll__nand2 with a behavioral NAND implementation
    assign out = ~(nand_out & or_out);

endmodule