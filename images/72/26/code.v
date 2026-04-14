module top_module(WCLK,D,WE,SPO,DPO,A,DPRA);input      WCLK; 
   input      D; 
   input      WE; 
   output     SPO; 
   output     DPO; 
   input [6:0] A; 
   input [6:0] DPRA; 
   parameter INIT = 128'd0;

   reg [127:0] ram = INIT;

   assign DPO = ram[DPRA];
   assign SPO=D;

   always @(posedge WCLK) begin
      if(WE) begin
         ram[A] <= D;
      end
   end



endmodule