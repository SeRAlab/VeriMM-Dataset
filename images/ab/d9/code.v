module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg [1:0] COMP
);always @* begin
    if (A < B) begin
      COMP <= 2'b00;
    end
    else if (A == B) begin
      COMP <= 2'b01;
    end
    else begin
      COMP <= 2'b10;
    end
  end

endmodule