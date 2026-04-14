module top_module(j, k, clk, q, qb);input j, k, clk;
  wire j, k, clk;

  output q, qb;
  reg q, qb;

  always @ (posedge clk)
  case ({j,k})
    2'b00: begin
             
             
           end
    2'b01: begin
             q <=1'b0;
             qb<=1'b1;
           end
    2'b10: begin
             q <=1'b1;
             qb<=1'b0;
           end
    2'b11: begin
             q <=qb;
             qb<= q;
           end
  endcase

endmodule