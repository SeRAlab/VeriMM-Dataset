module top_module(
         input A, B, Ci,
         output S, Co
       );reg ABsum;
reg ABcarry, Ccarry;

reg S_lcl, Co_lcl;

assign S = S_lcl;
assign Co = Co_lcl;


always @( * ) begin
  ABsum <= #10 A ^ B;
  S_lcl <= #10 Ci ^ ABsum;
end


always @( * ) begin
  Ccarry <= #10 ABsum & Ci;
  ABcarry <= #10 A & B;
  Co_lcl <= #10 Ccarry | ABcarry;
end

endmodule