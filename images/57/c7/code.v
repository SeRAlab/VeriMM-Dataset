module top_module(P);`ifdef XIL_TIMING

    parameter LOC = "UNPLACED";

`endif


    output P;

    assign P = 1'b1;

endmodule