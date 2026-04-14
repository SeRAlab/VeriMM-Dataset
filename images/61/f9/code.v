module top_module(
  input empty,
  input ge2_free,
  input ge3_free,
  input [1:0] input_tm_cnt,
  output reg [4:0] fifo_cnt_inc
);always @(empty or ge2_free or ge3_free or input_tm_cnt) begin
    if (empty) begin
      fifo_cnt_inc = input_tm_cnt;
    end
    else if (ge3_free && (input_tm_cnt == 2'b11)) begin
      fifo_cnt_inc = 2'b10;
    end
    else if (ge2_free && (input_tm_cnt >= 2'b10)) begin
      fifo_cnt_inc = 2'b01;
    end
    else if (input_tm_cnt >= 2'b01) begin
      fifo_cnt_inc = 2'b00;
    end
    else begin
      fifo_cnt_inc = 5'b11111;
    end
  end

endmodule