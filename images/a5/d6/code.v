module top_module(
  input SET, 
  input CK, 
  input D, 
  output Q, 
  output QN 
);reg q_reg;


always @ ( posedge CK or posedge SET)
if (SET) begin
  q_reg <= 1'b1;
end else begin
  q_reg <= D;
end

assign Q = q_reg;
assign QN = ~q_reg;endmodule