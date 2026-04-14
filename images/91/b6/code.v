module top_module(Clk, Reset, Seed, Enable, Data, Done);parameter Tp = 1;

input Clk;
input Reset;
input [15:0] Seed;
input Enable;

output reg [15:0] Data;
output reg Done;

reg [15:0] Lfsr;

always @ (posedge Clk or posedge Reset) begin
  if (Reset) begin
    Lfsr <= #Tp Seed;
    Data <= #Tp 16'h0000;
    Done <= #Tp 1'b0;
  end else if (Enable) begin
    Lfsr <= #Tp {Lfsr[14:0], Lfsr[0] ^ Lfsr[2] ^ Lfsr[3] ^ Lfsr[5]};
    Data <= #Tp Lfsr;
    Done <= #Tp 1'b1;
  end else begin
    Done <= #Tp 1'b0;
  end
end

endmodule