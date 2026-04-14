module top_module(input [23:1] M68K_ADDR,input [2:0] BNK,input nSROMOEU, nSROMOEL,output nSROMOE,input nVEC,output A23Z, A22Z,output [23:0] CDA);assign nSROMOE = nSROMOEU & nSROMOEL; 
  assign {A23Z, A22Z} = M68K_ADDR[23:22] ^ {2{~|{M68K_ADDR[21:7], ^M68K_ADDR[23:22], nVEC}}}; 
 endmodule