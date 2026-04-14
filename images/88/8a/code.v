module top_module(
  input CLK,
  input D,
  input R,
  input S,
  output reg Q
);always @(posedge CLK or negedge R or negedge S) begin
    if (!R) begin
      Q <= 1'b0;
    end else if (!S) begin
      Q <= 1'b1;
    end else begin
      Q <= D;
    end
  end

endmodule