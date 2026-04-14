module top_module(P, A, B, CARRYIN, CLK, RST);output reg [31:0] P;
  input [15:0] A;
  input [15:0] B;
  input CARRYIN;
  input CLK;
  input RST;

  reg [31:0] mult_reg;

  always @(posedge CLK)
    begin
    if(!RST)
        mult_reg <= 'b0;
    else
        mult_reg <= A * B;
    end

    always@(posedge CLK)
    begin
    if(!RST)
        P <= 'b0;
    else
`ifndef BUG
        P <= mult_reg + CARRYIN;
`else
        P <= mult_reg - CARRYIN;
`endif
    end

endmodule