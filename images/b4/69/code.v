module top_module(
  input clock, reset, enable,
  output reg [3:0] count
);always @(posedge clock) begin
    if (reset) begin
      count <= 4'b0;
    end else if (enable) begin
      count <= (count == 4'b1111) ? 4'b0 : count + 1;
    end
  end

endmodule