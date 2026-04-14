module top_module(
    input a,
    input b,
    output out
);wire nand1_out;
wire nand2_out;
wire inv_out;

// Correcting to use NOT gate instead of a custom inverter module
nand nand1(nand1_out, a, a); // Generates NOT a
nand nand2(nand2_out, b, b); // Generates NOT b
not inv(inv_out, nand1_out);  // Using NOT gate for inversion
nand nand3(out, nand2_out, inv_out); // Generate NOR from NAND outputs

endmodule