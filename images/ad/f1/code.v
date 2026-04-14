module top_module(
    input clk,
    input ce,
    input reset,
    input [15:0] prg_ain,
    output reg [21:0] prg_aout,
    input [13:0] chr_ain,
    output [21:0] chr_aout,
    input [3:0] mmc1_chr,
    input [21:0] mmc1_aout,
    output irq
);reg unlocked, old_val; 
  reg [29:0] counter; 
  reg [3:0] oldbits; 

  always @(posedge clk or posedge reset) begin
      if (reset) begin 
          old_val <= 0; 
          unlocked <= 0; 
          counter <= 0; 
          oldbits <= 4'b0000; // Initialize oldbits
      end else if (ce) begin 
          if (mmc1_chr[3] && !old_val) unlocked <= 1; 
          old_val <= mmc1_chr[3]; 
          counter <= mmc1_chr[3] ? 0 : counter + 1; 
          if (mmc1_chr != oldbits) begin 
              $write("NESEV Control Bits: %X => %X (%d)\n", oldbits, mmc1_chr, unlocked); 
              oldbits <= mmc1_chr; 
          end 
      end 
  end 

  assign irq = (counter[29:25] == 5'b10100); 

  always @(*) begin 
      if (!prg_ain[15]) begin 
          prg_aout = mmc1_aout; 
      end else if (!unlocked) begin 
          prg_aout = {7'b00_0000_0, prg_ain[14:0]}; 
      end else if (mmc1_chr[2] == 0) begin 
          prg_aout = {5'b00_000, mmc1_chr[1:0], prg_ain[14:0]}; 
      end else begin 
          prg_aout = mmc1_aout; 
      end 
  end 

  assign chr_aout = {9'b10_0000_000, chr_ain[12:0]}; 
endmodule