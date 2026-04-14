module mux_2to1_enable (
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  input en,
  output reg [7:0] out
);

always @(posedge clk, negedge reset) begin
  if (!reset) begin
    out <= 8'b0;
  end else begin
    if (en) begin
      if (a != 8'b0) begin
        out <= a;
      end else begin
        out <= b;
      end
    end else begin
      out <= 8'b0;
    end
  end
end

endmodule
