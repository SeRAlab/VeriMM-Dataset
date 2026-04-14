module top_module(
  input CK, 
  input D, 
  output Q, 
  output QN 
);reg q_reg;


always @ (posedge CK) begin 
  q_reg <= D;
end

assign Q = q_reg;
assign QN = ~q_reg;endmodule