module top_module(clk, reset_n, push, pop, cnt, xzcheck_enable);parameter depth=1;
  parameter push_width = 1;
  parameter pop_width = 1;
  parameter simultaneous_push_pop = 1;
  parameter cnt_reg_width = 1;
  input clk, reset_n;
  input [push_width-1:0] push;
  input [pop_width-1:0] pop;
  input [cnt_reg_width-1:0] cnt;
  input xzcheck_enable;

  reg [push_width-1:0] data;
  reg [cnt_reg_width-1:0] count;
  reg [pop_width-1:0] pop_req;
  reg [push_width-1:0] push_req;
  reg [simultaneous_push_pop-1:0] push_pop_req;
  reg [simultaneous_push_pop-1:0] push_pop_ack;

  always @(posedge clk) begin
    if (reset_n == 0) begin
      data <= 0;
      count <= 0;
      pop_req <= 0;
      push_req <= 0;
      push_pop_req <= 0;
      push_pop_ack <= 0;
    end else begin
      if (push_pop_ack == 0) begin
        if (pop_req == 1) begin
          data <= 0;
          count <= 0;
          pop_req <= 0;
          push_pop_ack <= 1;
        end else if (push_req == 1) begin
          data <= push;
          count <= 1;
          push_req <= 0;
          push_pop_ack <= 1;
        end else begin
          push_pop_ack <= 0;
        end
      end else begin
        push_pop_ack <= 0;
      end
    end
  end

  always @(posedge clk) begin
    if (reset_n == 0) begin
      push_pop_req <= 0;
    end else begin
      if (push_pop_ack == 0) begin
        if (count == 0) begin
          push_req <= push & ~pop_req;
          pop_req <= pop & ~push_req;
        end else begin
          push_req <= 0;
          pop_req <= pop & ~push_req;
        end
        push_pop_req <= push_req | pop_req;
      end else begin
        push_pop_req <= 0;
      end
    end
  end

  always @(posedge clk) begin
    if (reset_n == 0) begin
      push_pop_req <= 0;
    end else begin
      push_pop_req <= push_req | pop_req;
    end
  end

  // modeling layer code for asserted properties here

endmodule