module top_module(CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);input CLK;
  input [15:0]A;
  input [15:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [7:0]P;
  output [47:0]PCASC;

  wire [31:0]mult_result;
  wire [55:0]mult_result_extended;
  wire [63:0]mult_result_extended_zero_detect;

  assign mult_result = A * B;
  assign mult_result_extended = {8'b0, mult_result};
  assign mult_result_extended_zero_detect = {2'b0, mult_result_extended};

  assign P = mult_result[7:0];
  assign PCASC = mult_result_extended[47:0];
  assign ZERO_DETECT = (mult_result_extended_zero_detect == 0) ? 2'b11 : ((mult_result_extended_zero_detect[55:8] == 0) ? 2'b10 : 2'b01);

endmodule