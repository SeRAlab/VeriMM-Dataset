module top_module(A, B, C, D, S0, S1, Y);input A, B, C, D, S0, S1;
output Y;

  reg Y;

  always @(*) begin
    if(S0 == 0 && S1 == 0) begin
      Y = A;
    end else if(S0 == 0 && S1 == 1) begin
      Y = B;
    end else if(S0 == 1 && S1 == 0) begin
      Y = C;
    end else begin
      Y = D;
    end
  end

endmodule