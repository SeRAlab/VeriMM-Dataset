module top_module(
  input [1:0] A,
  input [1:0] B,
  input C,
  output reg D,
  output reg E
);always @(*) begin
    if ((A >= B) && C) begin
      D = 1;
    end else begin
      D = 0;
    end
    if ((A < B) && !C) begin
      E = 1;
    end else begin
      E = 0;
    end
  end

endmodule