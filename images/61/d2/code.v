module top_module(CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);input CLK;
  input [12:0]A;
  input [19:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [32:0]P;
  output [47:0]PCASC;

  reg [12:0]A_reg;
  reg [19:0]B_reg;
  reg CE_reg;
  reg CLK_reg;
  reg [32:0]P_reg;
  reg [47:0]PCASC_reg;
  reg SCLR_reg;
  reg [1:0]ZERO_DETECT_reg;

  assign A = A_reg;
  assign B = B_reg;
  assign CE = CE_reg;
  assign CLK = CLK_reg;
  assign P = P_reg;
  assign PCASC = PCASC_reg;
  assign SCLR = SCLR_reg;
  assign ZERO_DETECT = ZERO_DETECT_reg;

  always @(posedge CLK) begin
    if (SCLR == 1'b1) begin
      A_reg <= 13'b0;
      B_reg <= 20'b0;
      CE_reg <= 1'b0;
      CLK_reg <= 1'b0;
      P_reg <= 33'b0;
      PCASC_reg <= 48'b0;
      SCLR_reg <= 1'b1;
      ZERO_DETECT_reg <= 2'b11;
    end else if (CE == 1'b1) begin
      A_reg <= A;
      B_reg <= B;
      CE_reg <= CE;
      CLK_reg <= CLK;
      P_reg <= A_reg * B_reg;
      PCASC_reg <= {P_reg, 13'b0};
      SCLR_reg <= SCLR;
      ZERO_DETECT_reg <= (P_reg == 33'b0) ? 2'b10 : 2'b00;
    end
  end
endmodule