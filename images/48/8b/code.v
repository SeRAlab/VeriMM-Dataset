module top_module(
  input clk,
  input reset,
  input data,
  input load,
  input [1:0] amount,
  output reg [31:0] q
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 0;
    end else if (load) begin
      q <= data;
    end else begin
      case (amount)
        2'b00: q <= q << 4;
        2'b01: q <= q << 2;
        2'b10: q <= q >> 2;
        2'b11: q <= q >> 4;
      endcase
    end
  end

endmodule