module top_module(
  input atm_valid,
  input dtm_valid,
  input itm_valid,
  output reg [1:0] compute_input_tm_cnt // Changed 'wire' to 'reg'
);always @(*) begin
    case ({itm_valid, atm_valid, dtm_valid})
      3'b000: compute_input_tm_cnt = 2'b00;
      3'b001: compute_input_tm_cnt = 2'b01;
      3'b010: compute_input_tm_cnt = 2'b01;
      3'b011: compute_input_tm_cnt = 2'b10;
      3'b100: compute_input_tm_cnt = 2'b01;
      3'b101: compute_input_tm_cnt = 2'b10;
      3'b110: compute_input_tm_cnt = 2'b10;
      3'b111: compute_input_tm_cnt = 2'b11;
      default: compute_input_tm_cnt = 2'b00; // Added default case for safe synthesis
    endcase
  end

endmodule