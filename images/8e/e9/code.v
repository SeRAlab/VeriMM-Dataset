module top_module(
   // Generic synchronous double-port RAM interface
   clk_a, ce_a, addr_a, do_a,
   clk_b, ce_b, we_b, addr_b, di_b
   );//
   // Default address and data buses width
   //
   parameter aw = 5;
   parameter dw = 32;
   
   //
   // Generic synchronous double-port RAM interface
   //
   input clk_a; // Clock for port A
   input ce_a; // Chip enable for port A
   input [aw-1:0] addr_a; // Address bus inputs for port A
   output [dw-1:0] do_a; // Output data bus for port A
   input clk_b; // Clock for port B
   input ce_b; // Chip enable for port B
   input we_b; // Write enable for port B
   input [aw-1:0] addr_b; // Address bus inputs for port B
   input [dw-1:0] di_b; // Input data bus for port B
   
   //
   // Internal wires and registers
   //
   reg [dw-1:0] mem [(1<<aw)-1:0] /*synthesis syn_ramstyle = "no_rw_check"*/; // RAM content
   reg [aw-1:0] addr_a_reg; // RAM address registered
   integer k;
   
   //
   // Data output drivers
   //
   assign do_a = mem[addr_a_reg];
   
   //
   // RAM read
   //
   always @(posedge clk_a)
     if (ce_a)
       addr_a_reg <=  addr_a;
   
   //
   // RAM write
   //
   always @(posedge clk_b)
     if (ce_b & we_b)
       mem[addr_b] <=  di_b;
   
   //
   // RAM initialization
   //
   initial begin 
      for(k = 0; k < (1 << aw); k = k + 1)
      begin
         mem[k] = 0;
      end
   end
   
endmodule