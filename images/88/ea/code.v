module top_module(clk,reset,enable,npc,pc,pcplus);input  [31:0]  npc;
   input          clk,reset,enable;
   output [31:0]  pc,pcplus;

   reg [31:0]     internal_pc;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         internal_pc<=32'h00003000;
      end 
      else if(enable) begin
         internal_pc<=npc;
      end
   end

   assign pc=internal_pc;
   assign pcplus=internal_pc+4;

endmodule