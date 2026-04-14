module top_module(input[1:0] kind, input signed[31:0] valX, valY, valI,output reg signed[31:0] valA, valB, valC);always @* case (kind) 
  2'b00: {valA,valB,valC} = {valX ,valY,valI}; 
  2'b01: {valA,valB,valC} = {valX ,valI,valY}; 
  2'b10: {valA,valB,valC} = {valI ,valX,valY}; 
  2'b11: {valA,valB,valC} = {32'h0,valX,valI}; 
  endcase 
 endmodule