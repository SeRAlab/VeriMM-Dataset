module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] C
);always @(*) begin
    if(A < B) begin
      C = A;
    end
    else begin
      C = B;
    end
  end

endmodule