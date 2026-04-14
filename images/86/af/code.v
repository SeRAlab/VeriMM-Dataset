module top_module(
  input                clk,
  input                rst_n,
  output reg  [3:0]    Q
);reg [63:0] shift_reg;
  wire        xor_out;
  
  assign xor_out = shift_reg[0] ^ shift_reg[1] ^ shift_reg[2] ^ shift_reg[3] ^ shift_reg[4] ^ shift_reg[5] ^ shift_reg[6] ^ shift_reg[7] ^ shift_reg[8] ^ shift_reg[9] ^ shift_reg[10] ^ shift_reg[11] ^ shift_reg[12] ^ shift_reg[13] ^ shift_reg[14] ^ shift_reg[15] ^ shift_reg[16] ^ shift_reg[17] ^ shift_reg[18] ^ shift_reg[19] ^ shift_reg[20] ^ shift_reg[21] ^ shift_reg[22] ^ shift_reg[23] ^ shift_reg[24] ^ shift_reg[25] ^ shift_reg[26] ^ shift_reg[27] ^ shift_reg[28] ^ shift_reg[29] ^ shift_reg[30] ^ shift_reg[31] ^ shift_reg[32] ^ shift_reg[33] ^ shift_reg[34] ^ shift_reg[35] ^ shift_reg[36] ^ shift_reg[37] ^ shift_reg[38] ^ shift_reg[39] ^ shift_reg[40] ^ shift_reg[41] ^ shift_reg[42] ^ shift_reg[43] ^ shift_reg[44] ^ shift_reg[45] ^ shift_reg[46] ^ shift_reg[47] ^ shift_reg[48] ^ shift_reg[49] ^ shift_reg[50] ^ shift_reg[51] ^ shift_reg[52] ^ shift_reg[53] ^ shift_reg[54] ^ shift_reg[55] ^ shift_reg[56] ^ shift_reg[57] ^ shift_reg[58] ^ shift_reg[59] ^ shift_reg[60] ^ shift_reg[61] ^ shift_reg[62] ^ shift_reg[63];
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      shift_reg <= 64'b0;
      Q         <= 4'b0;
    end
    else begin
      shift_reg <= {shift_reg[62:0], xor_out};
      Q         <= shift_reg[63:60];
    end
  end
  
endmodule