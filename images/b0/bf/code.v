module top_module(
  input [7:0] A,
  input [7:0] B,
  input EN,
  output reg [7:0] Y
);always @ (A, B, EN) begin
    if(EN) begin
      Y <= A;
    end
    else begin
      Y <= B;
    end
  end

endmodule