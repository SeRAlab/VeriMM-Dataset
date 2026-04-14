module top_module(IN1_STB,
    OUT1_ACK,
    output_rs232_tx,
    OUT1_STB,
    INTERNAL_RST_reg,
    OUT1,
    IN1_ACK,
    ETH_CLK_OBUF);output IN1_STB;
  output OUT1_ACK;
  output [7:0]output_rs232_tx;
  input OUT1_STB;
  input INTERNAL_RST_reg;
  input [7:0]OUT1;
  input IN1_ACK;
  input ETH_CLK_OBUF;

  wire ETH_CLK_OBUF;
  wire IN1_ACK;
  wire IN1_STB;
  wire INTERNAL_RST_reg;
  wire [7:0]OUT1;
  wire OUT1_ACK;
  wire OUT1_STB;
  wire [7:0]output_rs232_tx;

  reg [7:0] output_rs232_tx_reg;
  reg IN1_STB_reg;
  reg OUT1_ACK_reg;

  always @(*) begin
    output_rs232_tx_reg = OUT1;
    IN1_STB_reg = OUT1_STB;
    if (INTERNAL_RST_reg) begin
      OUT1_ACK_reg = 0;
      IN1_STB_reg = 0;
    end else if (IN1_ACK) begin
      OUT1_ACK_reg = 1;
    end
  end

  assign output_rs232_tx = output_rs232_tx_reg;
  assign IN1_STB = IN1_STB_reg;
  assign OUT1_ACK = OUT1_ACK_reg;

endmodule