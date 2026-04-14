module top_module(
  EFUSEUSR
);parameter [31:0] SIM_EFUSE_VALUE = 32'h00000000;

`ifdef XIL_TIMING

  parameter LOC = "UNPLACED";

`endif

    
  output [31:0] EFUSEUSR;

  assign EFUSEUSR = SIM_EFUSE_VALUE;

  specify

      specparam PATHPULSE$ = 0;

  endspecify

endmodule