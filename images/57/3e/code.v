module top_module(input clk, en, output reg done, output reg[31:0] valZ,input[3:0] op, input signed[31:0] valA, valB, valC);reg signed[31:0] rY, rZ, rA, rB, rC; 
  reg[3:0] rop; 
  reg add, act, staged; 
  always @(posedge clk) begin 
  { rop , valZ , rA , rB , rC , done , add , act , staged } <= 
  { op , rZ , valA , valB , valC , add , act , staged , en } ; 
  if (staged) case (rop) 
  4'h0: rY <= (rA | rB) ; 4'h8: rY <= (rA |~ rB ); 
  4'h1: rY <= (rA & rB) ; 4'h9: rY <= (rA &~ rB ); 
  4'h2: rY <= (rA ^ rB) ; 4'ha: rY <= {rA[19:0],rB[11:0]}; 
  4'h3: rY <= (rA >>> rB) ; 4'hb: rY <= (rA >> rB ); 
  4'h4: rY <= (rA + rB) ; 4'hc: rY <= (rA - rB ); 
  4'h5: rY <= (rA * rB) ; 4'hd: rY <= (rA << rB ); 
  4'h6: rY <= {32{rA == rB}}; 4'he: rY <= {32{rA [rB] }}; 
  4'h7: rY <= {32{rA < rB}}; 4'hf: rY <= {32{rA >= rB }}; 
  endcase 
  if (act) rZ <= rY + rC; 
  end 
 endmodule