module top_module(
  input fra_result,
  input res,
  output reg mux_5_en,
  output reg mux_4_en,
  output reg incre_en,
  output reg decre_en,
  output reg incre_bit,
  output reg shift_right_en,
  output reg shift_left_en,
  output reg shift_right_bits
);always @(*) begin
    if(fra_result) begin
      mux_5_en = 1;
      mux_4_en = 1;
      incre_en = 1;
      decre_en = 0;
      incre_bit = 1;
      shift_right_en = 1;
      shift_left_en = 0;
      shift_right_bits = 1;
    end else if(!res) begin
      mux_5_en = 0;
      mux_4_en = 0;
      incre_en = 0;
      decre_en = 0;
      incre_bit = 0;
      shift_right_en = 0;
      shift_left_en = 0;
      shift_right_bits = 0;
    end
  end

endmodule