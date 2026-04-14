module top_module(
    input in1,
    input in2,
    output out
);reg subsig1 /*verilator public_flat_rd*/;
reg subsig2 /*verilator public_flat_rd*/;

assign out = in1 & in2;

`ifdef iverilog
   // stop icarus optimizing signals away
   wire redundant = subsig1 | subsig2;
`endif

endmodule