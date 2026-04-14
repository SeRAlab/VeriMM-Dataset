module square_wave_generator(
  input clk,
  input rst_n,
  output reg wave
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      wave <= 1'b0;
    end
    else begin
      wave <= ~wave;
    end
  end

endmodule