module top_module(
  input CLK,
  input EN,
  input [31:0] DATA_IN,
  output [31:0] DATA_OUT_1,
  output [31:0] DATA_OUT_2,
  output [31:0] DATA_OUT_3
);reg [31:0] data_reg_1, data_reg_2, data_reg_3;

  always @(posedge CLK) begin
    if (EN) begin
      data_reg_3 <= data_reg_2;
      data_reg_2 <= data_reg_1;
      data_reg_1 <= DATA_IN;
    end
  end

  assign DATA_OUT_1 = data_reg_2;
  assign DATA_OUT_2 = data_reg_3;
  assign DATA_OUT_3 = DATA_IN;

endmodule