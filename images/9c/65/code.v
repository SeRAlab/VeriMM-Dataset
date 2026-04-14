module top_module(input printclk);always @ (posedge printclk) $write("[%0t] %m: Clocked\n", $time);
endmodule