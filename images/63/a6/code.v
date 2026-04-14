module top_module(
  input SET, 
  input RST, 
  input CK, 
  input SE, 
  input D, 
  input SI, 
  output Q, 
  output QN 
);reg q_reg;


always @ ( posedge CK or posedge RST or posedge SET)
if (RST) begin
  q_reg <= 1'b0;
end else if (SET) begin
  q_reg <= 1'b1;
end else if (SE) begin
  q_reg <= SI;
end else begin
  q_reg <= D;
end

assign Q = q_reg;
assign QN = !Q;endmodule