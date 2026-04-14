module top_module(
  input CLK, RST, EN,
  output reg [3:0] Q
);always @(posedge CLK) begin
    if (RST) begin
      Q <= 4'b0;
    end else if (EN) begin
      Q <= Q + 1;
      if (Q == 4'hF) begin
        Q <= 4'h0;
      end
    end
  end

endmodule