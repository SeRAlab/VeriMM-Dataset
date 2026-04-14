module top_module(input wire Clock,input wire [7:0] iRegistro,input wire [3:0] iBits_a_correr,output reg [7:0] oRegistro_corrido);always @(posedge Clock) 
  case(iBits_a_correr) 
  0: oRegistro_corrido <= iRegistro; 
  1: oRegistro_corrido <= iRegistro << 1; 
  2: oRegistro_corrido <= iRegistro << 2; 
  3: oRegistro_corrido <= iRegistro << 3; 
  4: oRegistro_corrido <= iRegistro << 4; 
  5: oRegistro_corrido <= iRegistro << 5; 
  6: oRegistro_corrido <= iRegistro << 6; 
  7: oRegistro_corrido <= iRegistro << 7; 
  endcase 
 endmodule