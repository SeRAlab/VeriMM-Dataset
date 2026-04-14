module counter (
  input CLK,
  input RST,
  input EN,
  output reg [3:0] COUNT
);

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      COUNT <= 4'b0;
    end else if (EN) begin
      COUNT <= COUNT + 1;
    end
  end

endmodule