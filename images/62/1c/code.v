module top_module(
   clock,
   reset_b,

   // CPU Signals
   ext_cs_b,
   cpu_rnw,
   cpu_clken,
   cpu_addr,
   cpu_dout,
   ext_dout,

   // Ram Signals
   ram_cs_b,
   ram_oe_b,
   ram_we_b,
   ram_data_out,
   ram_addr
   );parameter DSIZE        = 32;
   parameter ASIZE        = 20;

   input                 clock;
   input                 reset_b;

   // CPU Signals
   input                 ext_cs_b;
   input                 cpu_rnw;
   output                cpu_clken;
   input [ASIZE-1:0]     cpu_addr;
   input [DSIZE-1:0]     cpu_dout;
   output [DSIZE-1:0]    ext_dout;

   // Ram Signals
   output                ram_cs_b;
   output                ram_oe_b;
   output                ram_we_b;
   output [17:0]         ram_addr;

   output [15:0]         ram_data_out;

   wire                  ext_a_lsb;
   reg [15:0]            ram_data_last;
   reg                   count;

   // Count 0..1 during external memory cycles
   always @(posedge clock)
     count <= !ext_cs_b;

   // Drop clken for 1 cycle during an external memory access
   assign cpu_clken = !(!ext_cs_b && !count);

   // A0 = 0 for count 0 (low half-word) and A0 = 1 for count 1 (high half-word)
   assign ext_a_lsb = count;
   
   // The low byte is registered at the end of cycle 0
   // The high byte is consumed directly from RAM at the end of cycle 1
   always @(posedge clock)
     ram_data_last <= ram_data_out[15:0];

   assign ext_dout = { ram_data_out[15:0], ram_data_last };

   // ---------------------------------------------
   // external RAM
   // ---------------------------------------------

   assign ram_addr = {cpu_addr[16:0], ext_a_lsb};
   assign ram_cs_b = ext_cs_b;
   assign ram_oe_b = !cpu_rnw;
   assign ram_we_b = ext_cs_b | cpu_rnw | (!clock);

   assign ram_data_out  = ext_a_lsb == 1 ? cpu_dout[31:16]  :
                                           cpu_dout[15:0]   ;

endmodule