module top_module(input wire inclk0,
            output wire c0,
            output wire c1,
            output wire locked,
            output wire e0);assign          c0 = inclk0;
   assign          c1 = inclk0;
   assign          locked = 1;
   assign          e0 = inclk0;
endmodule