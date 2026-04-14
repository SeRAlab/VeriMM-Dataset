module freq_divider(
  input clk,
  input rst_n,
  output reg clk_out
);

  reg [1:0] counter;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      counter <= 2'b00;
      clk_out <= 1'b0;
    end else begin
      if (counter == 2'b11) begin
        counter <= 2'b00;
        clk_out <= ~clk_out;
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule