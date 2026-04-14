module top_module(
	input clock,
   input enable,
	
	input ld_seed,
   input [7:0] seedData,
 
   output [7:0] outData
   );reg [8:1] r_LFSR = 0;
   reg              r_XNOR;
	
	
   
   always @(posedge clock) begin
      if (enable == 1'b1)
         begin
            if (ld_seed == 1'b1)
               r_LFSR <= seedData;
            else
               r_LFSR <= {r_LFSR[7:1], r_XNOR};
         end
   end
	
   
   
   always @(*) begin
      r_XNOR = r_LFSR[8] ^~ r_LFSR[6] ^~ r_LFSR[5] ^~ r_LFSR[4];
   end
   
   assign outData = r_LFSR[8:1];endmodule