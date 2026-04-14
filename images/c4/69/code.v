module compute_tm_count (
  input atm_valid,
  input dtm_valid,
  input itm_valid,
  output reg [1:0] compute_tm_count
);

  always @(*) begin
    case ({itm_valid, atm_valid, dtm_valid})
      3'b000: compute_tm_count = 2'b00;
      3'b001: compute_tm_count = 2'b01;
      3'b010: compute_tm_count = 2'b01;
      3'b011: compute_tm_count = 2'b10;
      3'b100: compute_tm_count = 2'b01;
      3'b101: compute_tm_count = 2'b10;
      3'b110: compute_tm_count = 2'b10;
      3'b111: compute_tm_count = 2'b11;
    endcase
  end

endmodule