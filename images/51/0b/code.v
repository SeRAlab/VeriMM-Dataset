module frequency_divider(
  input clk_in,
  input rst_n,
  output reg clk_out
);

  reg [1:0] counter;
  
  always @(posedge clk_in or negedge rst_n) begin
    if (~rst_n) begin
      counter <= 2'b00;
      clk_out <= 0;
    end
    else begin
      counter <= counter + 1;
      if (counter == 2'b11) begin
        clk_out <= ~clk_out;
        counter <= 2'b00;
      end
    end
  end

endmodule