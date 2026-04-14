module top_module( Phi, FS, notFS, Res,
                  notShiftCount1 );input Phi, FS, notFS;
   input [1:0] Res;
   output notShiftCount1 ;
   // shift count decrementer.
   // Load counter from Res on FS
   // decrement works either loading or counting

   wire [1:0] notSC, ShCnt, notShCnt;

   // Replace missing modules with behavioral descriptions
   wire [1:0] mux_out;
   assign mux_out[1] = (FS) ? Res[1] : notShCnt[1];
   assign mux_out[0] = (FS) ? Res[0] : notShCnt[0];

   // Shift Count Flip-Flops
   reg [1:0] sh_cnt;
   wire clk = Phi;

   always @(posedge clk)
   begin
       sh_cnt[1] <= mux_out[1]; 
       sh_cnt[0] <= mux_out[0]; 
   end

   assign notShCnt = ~sh_cnt;

   // NAND gate to output the complement of the new shift count value after decrementing
   assign notShiftCount1 = ~(notFS & notShCnt[1] & sh_cnt[0]);

endmodule