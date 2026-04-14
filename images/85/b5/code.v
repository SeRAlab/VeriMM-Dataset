module top_module(
   // Generic synchronous 4-port RAM interface
   clk, ce, we, addr, di, doq
   );//
   // Default address and data buses width
   //
   parameter aw = 10;
   parameter dw = 32;
   
   //
   // Generic synchronous 4-port RAM interface
   //
   input 				  clk;	// Clock
   input 				  ce;	// Chip enable input
   input [3:0]				  we;	// Write enable input
   input [aw-1:0] 			  addr;	// address bus inputs
   input [dw-1:0] 			  di;	// input data bus
   output [dw-1:0] 			  doq;	// output data bus
   
   //
   // Internal wires and registers
   //

   //
   // 4-port synchronous RAM model
   //
   
   //
   // 4-port RAM's registers and wires
   //
   reg [dw-1:0] 				  mem0 [(1<<aw)-1:0] /*synthesis syn_ramstyle = "no_rw_check"*/;
   reg [dw-1:0] 				  mem1 [(1<<aw)-1:0] /*synthesis syn_ramstyle = "no_rw_check"*/;
   reg [dw-1:0] 				  mem2 [(1<<aw)-1:0] /*synthesis syn_ramstyle = "no_rw_check"*/;
   reg [dw-1:0] 				  mem3 [(1<<aw)-1:0] /*synthesis syn_ramstyle = "no_rw_check"*/;
   reg [aw-1:0] 			  addr_reg;		// RAM address register
   
   //
   // Data output drivers
   //
   assign doq = {mem0[addr_reg], mem1[addr_reg], mem2[addr_reg], mem3[addr_reg]};
   
   //
   // RAM read address register
   //
   always @(posedge clk)
     if (ce)
       addr_reg <=  addr;
   
   //
   // RAM write - big endian selection
   //
   always @(posedge clk)
     if (ce) begin
       if (we[3])
         mem0[addr] <=  di[31:24];
       if (we[2])
         mem1[addr] <=  di[23:16];
       if (we[1])
         mem2[addr] <=  di[15:08];
       if (we[0])
         mem3[addr] <=  di[07:00];
     end
   
endmodule