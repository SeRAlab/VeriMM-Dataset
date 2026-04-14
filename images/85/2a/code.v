module top_module(
  input clk,
  input shiftnld,
  input ldsrc,
  output crcerror,
  output regout
);parameter oscillator_divider = 1;
  parameter lpm_type = "cycloneii_crcblock";
  
  reg [31:0] crc_reg;
  wire feedback;
  
  assign feedback = crc_reg[31] ^ crc_reg[29] ^ crc_reg[28] ^ crc_reg[26];
  assign crcerror = (crc_reg != 32'hFFFFFFFF);
  assign regout = crc_reg;
  
  always @(posedge clk) begin
    if (ldsrc) begin
      crc_reg <= 32'hFFFFFFFF;
    end else if (shiftnld) begin
      crc_reg <= {crc_reg[30:0], feedback};
    end
  end
  
endmodule