module top_module(
  input [31:0] div,
  input [31:0] divisor,
  output reg [31:0] rem
);always @(*) begin
  if (divisor == 0) begin
    $display("Error: Division by zero.");
    rem = 32'h0000_0000;
  end else begin
    rem = div % divisor;
  end
end

endmodule