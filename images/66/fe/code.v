module top_module(CLKIN, ACLR_L, CLKOUT);input CLKIN, ACLR_L;
output CLKOUT;

reg CLKOUT;
reg [5:0] divcnt_i;
wire clkdiv_roll;

assign clkdiv_roll = (divcnt_i == 49);

always @(posedge CLKIN or negedge ACLR_L)
   begin
      if(ACLR_L == 1'b0)
         divcnt_i <= 6'b000000;
      else if(clkdiv_roll == 1'b1)
         divcnt_i <= 6'b000000;
      else
         divcnt_i <= divcnt_i + 1;
   end

always @(posedge CLKIN or negedge ACLR_L)
   begin
      if(ACLR_L == 1'b0)
         CLKOUT <= 1'b0;
      else if(clkdiv_roll == 1'b1)
         CLKOUT <= ~CLKOUT;
   end

endmodule