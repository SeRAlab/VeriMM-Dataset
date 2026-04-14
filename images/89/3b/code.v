module top_module(
  input RSTN, 
  input CK, 
  input D, 
  output Q, 
  output QN 
);reg q_reg;


always @ ( posedge CK or negedge RSTN)
if (~RSTN) begin
  q_reg <= 1'b0;
end else begin
  q_reg <= D;
end

assign Q = q_reg;
assign QN = ~q_reg;endmodule