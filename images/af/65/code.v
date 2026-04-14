module top_module(
  input wire ge2_free,
  input wire ge3_free,
  input wire [1:0] input_tm_cnt,
  output reg [3:0] fifo_wrptr_inc
);always @*
  begin
    if (ge3_free && (input_tm_cnt == 2'd3))
      fifo_wrptr_inc = 4'd3;
    else if (ge2_free && (input_tm_cnt >= 2'd2))
      fifo_wrptr_inc = 4'd2;
    else if (input_tm_cnt >= 2'd1)
      fifo_wrptr_inc = 4'd1;
    else
      fifo_wrptr_inc = 4'd0;
  end

endmodule