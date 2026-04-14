module top_module(output Y, input A);specparam Delay = 0.1;

  assign #Delay Y = A;

endmodule