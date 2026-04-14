module top_module(input wire dtr,
                 input wire rts,
                 input wire rx,
                 input wire tx2,
                 output wire tx,
                 output wire rx2,
                 output wire D1,
                 output wire D2);assign D1 = dtr;
assign D2 = rts;


assign rx2 = rx;
assign tx = tx2;

endmodule