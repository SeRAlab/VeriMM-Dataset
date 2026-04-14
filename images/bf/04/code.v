module top_module(
  output nfl_num,
  output inc_dec_b,
  input cfg_err_cpl_timeout_n,
  input decr_nfl,
  input rst,
  input clk
);parameter FFD = 1; // clock to out delay model

  reg to_incr;
  reg add_sub_b;

  always @ (cfg_err_cpl_timeout_n or decr_nfl) begin
    case ({cfg_err_cpl_timeout_n, decr_nfl})
      2'b10: begin
        to_incr = 1'b0;
        add_sub_b = 1'b1;
      end
      2'b11: begin
        to_incr = 1'b1;
        add_sub_b = 1'b0;
      end
      2'b00: begin
        to_incr = 1'b1;
        add_sub_b = 1'b1;
      end
      2'b01: begin
        to_incr = 1'b0;
        add_sub_b = 1'b1;
      end
      default: begin
        to_incr = 1'b0;
        add_sub_b = 1'b1;
      end
    endcase
  end

  reg reg_nfl_num;
  reg reg_inc_dec_b;

  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      reg_nfl_num <= #FFD 1'b0;
      reg_inc_dec_b <= #FFD 1'b0;
    end else begin
      reg_nfl_num <= #FFD to_incr ? reg_nfl_num + 1 : reg_nfl_num - 1;
      reg_inc_dec_b <= #FFD add_sub_b;
    end
  end

  assign nfl_num = reg_nfl_num;
  assign inc_dec_b = reg_inc_dec_b;

endmodule