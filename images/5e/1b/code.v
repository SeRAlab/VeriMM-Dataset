module top_module(
  input [1:0] input_tm_cnt,
  input empty,
  input ge2_free,
  input ge3_free,
  output reg [4:0] fifo_cnt_inc
);always @(*) begin
    if (empty) begin
      fifo_cnt_inc = input_tm_cnt;
    end else if (ge3_free && input_tm_cnt == 2'b11) begin
      fifo_cnt_inc = 2'b10;
    end else if (ge2_free && input_tm_cnt >= 2) begin
      fifo_cnt_inc = 2'b01;
    end else if (input_tm_cnt >= 1) begin
      fifo_cnt_inc = 2'b00;
    end else begin
      fifo_cnt_inc = 5'b11111;
    end
  end

endmodule