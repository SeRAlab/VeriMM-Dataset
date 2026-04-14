module top_module(source, drain);input source;

  output drain;
  reg drain;

  reg connect1, connect2;

  always @(source) begin: mult_procs_1
    connect1 = ! source;
  end

  always @(connect1) begin: mult_procs_2
    connect2 = ! connect1;
  end
  
  always @(connect2) begin: mult_procs_3
    drain = ! connect2;
  end
endmodule