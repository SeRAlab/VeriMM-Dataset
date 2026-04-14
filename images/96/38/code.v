module top_module(what_on_bus, ld, storage);input [15:0] what_on_bus;
   input ld;
   output [15:0] storage;

   reg [15:0] storage;

   always @(posedge ld) storage = what_on_bus;endmodule