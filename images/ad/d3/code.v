module top_module(
  input clock,
  input enable,
  output reg gated_clock // Change output to reg type
);always @ (posedge clock) begin
    if (enable) begin
      gated_clock <= clock;
    end else begin
      gated_clock <= 1'b0;
    end
  end

endmodule