module top_module(
  input clk0,
  input bslipcntl,
  input bsliprst,
  input datain,
  input x_on_bitslip,
  output bslipmax,
  output dataout
);parameter channel_width = 10;
  parameter bitslip_rollover = 12;
  
  reg [channel_width-1:0] data_reg;
  reg [channel_width-1:0] shifted_data;
  reg [bitslip_rollover-1:0] shift_reg;
  reg [1:0] corrupt_count;
  reg [1:0] corrupt_bits;
  reg start_corrupt_bits;
  reg bslipmax_tmp;
  reg ix_on_bitslip;

  assign dataout = (start_corrupt_bits == 1'b0) ? shifted_data : (corrupt_count < 3) ? 1'bx : shifted_data;
  assign bslipmax = bslipmax_tmp;

  always @(posedge clk0) begin
    if (bsliprst) begin
      data_reg <= 0;
      shifted_data <= 0;
      shift_reg <= 0;
      corrupt_count <= 0;
      corrupt_bits <= 0;
      start_corrupt_bits <= 0;
      bslipmax_tmp <= 0;
    end else begin
      if (bslipcntl) begin
        shift_reg <= {shift_reg[bitslip_rollover-2:0], data_reg[channel_width-1]};
        if (ix_on_bitslip == 1) start_corrupt_bits <= 1;
        if (corrupt_count == 2) start_corrupt_bits <= 0;
        if (start_corrupt_bits) corrupt_count <= corrupt_count + 1;
        else corrupt_count <= 0;
        if (corrupt_count == 0) corrupt_bits <= 0;
        else corrupt_bits <= {corrupt_bits[0], data_reg[channel_width-1]};
        if (corrupt_count < 3) shifted_data <= shift_reg;
      end else begin
        shifted_data <= data_reg;
        shift_reg <= {shift_reg[bitslip_rollover-2:0], data_reg[channel_width-1]};
        corrupt_count <= 0;
        corrupt_bits <= 0;
        start_corrupt_bits <= 0;
      end
      if (shift_reg == 0) bslipmax_tmp <= 1;
      else bslipmax_tmp <= 0;
      data_reg <= {data_reg[channel_width-2:0], datain};
    end
  end

  initial begin
    if (x_on_bitslip == 1) ix_on_bitslip <= 1;
    else ix_on_bitslip <= 0;
  end

endmodule