module top_module(
  input CLK,
  input RST,
  input D,
  output reg Q,
  output reg QN
);always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      Q <= 1'b0;
      QN <= 1'b1;
    end else begin
      Q <= D;
      QN <= ~D;
    end
  end

endmodule