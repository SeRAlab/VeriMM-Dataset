module top_module(input [1:0] select_ms,input [7:0] Hmm,input [7:0] Hmc,input [7:0] Hcm,input [7:0] Ecm,input [7:0] Fmc,output [7:0] Hcc,output [7:0] Ecc,output [7:0] Fcc);wire [7:0] Hcc0; 
 wire [7:0] Ecc0; 
 wire [7:0] Ecc1; 
 wire [7:0] Fcc0; 
 wire [7:0] Fcc1; 
 wire [7:0] ms; 
 assign ms = ( select_ms == 2'b00) ? -8'd4 : (( select_ms == 2'b01) ? -8'd1 : 8'd1); 
 assign Hcc0 = Hmm + ms; 
 assign Ecc0 = Hcm - 8'd6; 
 assign Ecc1 = Ecm - 8'd1; 
 assign Fcc0 = Hmc - 8'd6; 
 assign Fcc1 = Fmc - 8'd1; 
 wire [7:0] Ecc_max_Fcc; 
 assign Ecc_max_Fcc = ( Ecc > Fcc) ? Ecc : Fcc; 
 assign Hcc = ( Hcc0 > Ecc_max_Fcc) ? Hcc0 : Ecc_max_Fcc; 
 assign Ecc = ( Ecc0 > Ecc1) ? Ecc0 : Ecc1; 
 assign Fcc = ( Fcc0 > Fcc1) ? Fcc0 : Fcc1; 
 endmodule