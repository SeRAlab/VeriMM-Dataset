module top_module(
   
   DPO, SPO,
   
   A0, A1, A2, A3, A4, D, DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, WCLK, WE
   );input A0;
   input A1;
   input A2;
   input A3;
   input A4;
   input D;
   input DPRA0;
   input DPRA1;
   input DPRA2;
   input DPRA3;
   input DPRA4;
   input WCLK;
   input WE;
   
   
   output DPO;
   output SPO;

   assign DPO=1'b0;
   assign SPO=1'b0;
   
  
endmodule