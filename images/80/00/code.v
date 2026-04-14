module top_module(
  input                clk,
  input                rst_n,
  output reg  [63:0]   Q
);reg [63:0] lfsr;
  reg [5:0]  feedback;

  always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      lfsr <= 64'h0000_0000_0000_0000;
      feedback <= 6'h2D;
    end
    else begin
      lfsr <= {lfsr[62:0], lfsr[63] ^ lfsr[feedback]};
    end
  end

  always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q <= 64'h0000_0000_0000_0000;
    end
    else begin
      Q <= {lfsr[0], lfsr[2], lfsr[3], lfsr[6], lfsr[7], lfsr[8], lfsr[10], lfsr[11], lfsr[12], lfsr[14], lfsr[15], lfsr[16], lfsr[18], lfsr[19], lfsr[20], lfsr[22], lfsr[23], lfsr[24], lfsr[26], lfsr[27], lfsr[28], lfsr[30], lfsr[31], lfsr[32], lfsr[34], lfsr[35], lfsr[36], lfsr[38], lfsr[39], lfsr[40], lfsr[42], lfsr[43], lfsr[44], lfsr[46], lfsr[47], lfsr[48], lfsr[50], lfsr[51], lfsr[52], lfsr[54], lfsr[55], lfsr[56], lfsr[58], lfsr[59], lfsr[60], lfsr[62]};
    end
  end

endmodule