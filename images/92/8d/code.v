module top_module(input ext_clock, output pll_clock, input nrst, output lock);wire dummy_out;
   wire bypass, lock1;

   assign bypass = 1'b0;

   // Ensure null definitions for SB_PLL40_CORE, use specific FPGA tools for instantiation.
   // The module below is an example placeholder
   `ifdef FPGA
   SB_PLL40_CORE #(
       .FEEDBACK_PATH("SIMPLE"), 
       .PLLOUT_SELECT("GENCLK"),
       .DIVR(4'd0), 
       .DIVF(7'b1000111), 
       .DIVQ(3'b011),
       .FILTER_RANGE(3'b001)
   ) mypll1 (
       .REFERENCECLK(ext_clock),
       .PLLOUTGLOBAL(pll_clock), 
       .PLLOUTCORE(dummy_out), 
       .LOCK(lock1),
       .RESETB(nrst), 
       .BYPASS(bypass)
   );
   `else
       // Placeholder for simulation if hardware module is unavailable
       assign pll_clock = ext_clock; // Bypass actual PLL for simulation
       assign lock = 1'b1; // Always 'locked' for simulation purposes
   `endif
endmodule