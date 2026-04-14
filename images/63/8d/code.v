module top_module();`ifdef PUB_FUNC
   /* Public variable accessible outside the module */
   reg GSR;
   task setGSR;
      /* verilator public */
      input value;
      GSR = value;
   endtask
`else
   /* Private variable inaccessible outside the module */
   reg GSR;
`endif
endmodule