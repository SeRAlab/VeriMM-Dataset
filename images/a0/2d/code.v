module top_module(
  input clk,
  input reset,
  input up_down,
  output reg [3:0] count_out,
  output reg overflow,
  output reg underflow
);always @(posedge clk or negedge reset) begin
    if (!reset) begin
      count_out <= 4'b0000;
      overflow <= 1'b0;
      underflow <= 1'b0;
    end else begin
      if (up_down) begin // count up
        if (count_out == 4'b1111) begin
          count_out <= 4'b0000;
          overflow <= 1'b1;
        end else begin
          count_out <= count_out + 1;
          overflow <= 1'b0;
        end
        underflow <= 1'b0;
      end else begin // count down
        if (count_out == 4'b0000) begin
          count_out <= 4'b1111;
          underflow <= 1'b1;
        end else begin
          count_out <= count_out - 1;
          underflow <= 1'b0;
        end
        overflow <= 1'b0;
      end
    end
  end

endmodule