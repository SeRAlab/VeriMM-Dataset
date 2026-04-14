module top_module(
  input clk,
  input reset,
  input [15:0] data,
  input [1:0] ena,
  output reg [15:0] q
);always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
    end else begin
      case (ena)
        2'b00: q <= data; // no operation
        2'b01: q <= {q[14:0], ena[0] ? 1'b0 : q[15]}; // logical right shift
        2'b10: q <= {ena[0] ? q[15] : q[14], q[15:1]}; // logical left shift
        2'b11: q <= {q[14:0], ena[0] ? q[15] : 1'b0}; // arithmetic right shift
        2'b11: q <= {ena[0] ? q[15] : q[14], q[15:1], ena[0] ? q[15] : 1'b0}; // arithmetic left shift
      endcase
    end
  end

endmodule