module top_module(input [127:0] in,input [ 4:0] sel,output reg [ 3:0] out);always @(in or sel) 
  case (sel) 
  5'h00: out <= in[ 3: 0]; 
  5'h01: out <= in[ 7: 4]; 
  5'h02: out <= in[ 11: 8]; 
  5'h03: out <= in[ 15: 12]; 
  5'h04: out <= in[ 19: 16]; 
  5'h05: out <= in[ 23: 20]; 
  5'h06: out <= in[ 27: 24]; 
  5'h07: out <= in[ 31: 28]; 
  5'h08: out <= in[ 35: 32]; 
  5'h09: out <= in[ 39: 36]; 
  5'h0a: out <= in[ 43: 40]; 
  5'h0b: out <= in[ 47: 44]; 
  5'h0c: out <= in[ 51: 48]; 
  5'h0d: out <= in[ 55: 52]; 
  5'h0e: out <= in[ 59: 56]; 
  5'h0f: out <= in[ 63: 60]; 
  5'h10: out <= in[ 67: 64]; 
  5'h11: out <= in[ 71: 68]; 
  5'h12: out <= in[ 75: 72]; 
  5'h13: out <= in[ 79: 76]; 
  5'h14: out <= in[ 83: 80]; 
  5'h15: out <= in[ 87: 84]; 
  5'h16: out <= in[ 91: 88]; 
  5'h17: out <= in[ 95: 92]; 
  5'h18: out <= in[ 99: 96]; 
  5'h19: out <= in[103:100]; 
  5'h1a: out <= in[107:104]; 
  5'h1b: out <= in[111:108]; 
  5'h1c: out <= in[115:112]; 
  5'h1d: out <= in[119:116]; 
  5'h1e: out <= in[123:120]; 
  5'h1f: out <= in[127:124]; 
  endcase 
 endmodule