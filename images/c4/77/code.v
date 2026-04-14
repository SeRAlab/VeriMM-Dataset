module BOR (
  input Vin,
  input Vth,
  input clk,
  input reset,
  output rst_out
);

  reg bor_ff;

  always @ (posedge clk or negedge reset) begin
    if (!reset) begin
      bor_ff <= 0;
    end else begin
      if (Vin < Vth) begin
        bor_ff <= 1;
      end else begin
        bor_ff <= 0;
      end
    end
  end

  assign rst_out = bor_ff;

endmodule