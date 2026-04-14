module top_module(data_a, address_a, wren_a, rden_a, q_a, data_b, address_b, wren_b, rden_b, q_b, clock);parameter RAM_DEPTH = 256;
   parameter RAM_WIDTH = 36;
   parameter ADDR_WIDTH = 8;

   reg [RAM_WIDTH-1:0] ram [0:RAM_DEPTH-1];

   input [RAM_WIDTH-1:0] data_a, data_b;
   input [ADDR_WIDTH-1:0] address_a, address_b;
   input wren_a, rden_a, wren_b, rden_b, clock;
   output reg [RAM_WIDTH-1:0] q_a, q_b; // Change to reg type

   always @(posedge clock) begin
      if (wren_a) ram[address_a] <= data_a;
      if (rden_a) q_a <= ram[address_a]; // q_a is now a valid l-value
      if (wren_b) ram[address_b] <= data_b;
      if (rden_b) q_b <= ram[address_b]; // q_b is now a valid l-value
   end

endmodule