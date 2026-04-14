module top_module(
  input d,
  input clk,
  input reset,
  input load,
  output q
);reg q_reg;

  always @ (posedge clk) begin
    if (reset) begin
      q_reg <= 1'b0;
    end else if (load) begin
      q_reg <= d;
    end else begin
      q_reg <= d;
    end
  end

  assign q = q_reg;

endmodule