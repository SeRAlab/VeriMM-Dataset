module counter_4bit(
  input clk,
  input reset,
  output reg [3:0] count_out
);

  always @(posedge clk) begin
    if(reset) begin
      count_out <= 4'b0;
    end else begin
      count_out <= count_out + 1;
    end
  end

endmodule