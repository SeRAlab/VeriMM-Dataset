module top_module(
  input SETN, 
  input CK, 
  input D, 
  output Q, 
  output QN 
);reg q_reg;


always @ ( posedge CK or negedge SETN)
if (~SETN) begin
  q_reg <= 1'b1;
end else begin
  q_reg <= D;
end

assign Q = q_reg;
assign QN = ~q_reg;endmodule