module top_module(ictmr_o,icm_o,icov_i,icbne_i,icconf_o,icconf_i);output [1:0] ictmr_o;
output [2:0] icm_o;
input icov_i;
input icbne_i;
output [31:0] icconf_o;
input [31:0] icconf_i;

reg [1:0] ictmr_o;
reg [2:0] icm_o;
reg [31:0] icconf_o;

reg [31:0] icconf_reg;



always @(icov_i or icbne_i or icconf_i )
   begin

   icconf_reg  =((icconf_i &'hFFE7 )|(icbne_i <<3)|(icov_i <<4));

   icconf_o  =(icconf_reg );
   icm_o  =(icconf_reg &'h7);
   ictmr_o  =((icconf_reg &'h60)>>5);

   end

endmodule