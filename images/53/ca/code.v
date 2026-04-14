module top_module(
  input CLK,
  input EN,
  input TE,
  input [6:0] DATA_IN,
  output reg [6:0] DATA_OUT,
  output ENCLK
);reg [6:0] data_out_reg;

  always @(posedge CLK) begin
    if (EN) begin
      data_out_reg <= {DATA_IN[6], data_out_reg[6:1]};
    end
  end

  always @(posedge CLK) begin
    if (EN) begin
      DATA_OUT <= data_out_reg;
    end
  end

  assign ENCLK = data_out_reg[0];

endmodule