module top_module(
  input CLK,
  input EN,
  input RST,
  output reg [1:0] Q
);always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Q <= 2'b0;
    end else if (EN) begin
      Q <= Q + 1;
    end
  end

endmodule