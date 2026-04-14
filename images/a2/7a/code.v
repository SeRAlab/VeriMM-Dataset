module top_module(input wire dtr,
                 input wire rts,
                 input wire rx,
                 output wire tx,
                 output wire D1,
                 output wire D2);assign D1 = dtr;
assign D2 = rts;


assign tx = rx;

endmodule