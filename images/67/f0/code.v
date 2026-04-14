module top_module(input a
              , input b
              , input [7:0] c
              , output wire c1);assign c1 = (a || b) || (&c[7:0]);

endmodule