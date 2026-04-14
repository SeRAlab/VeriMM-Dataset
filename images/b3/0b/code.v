module top_module(clk, clr, inst_done, rom_inst, rom_done);input clk, clr, inst_done; 
  output reg [7:0] rom_inst; 
  output reg rom_done; 
  reg [3:0] PC; 
  always@(posedge clk) 
  if(clr) 
  PC <= 0; 
  else if(~rom_done) 
  begin 
  if(inst_done & (PC < 10)) 
  PC <= PC + 1; 
  end 
  else 
  PC <= 0; 
  always@(*) 
  begin 
  rom_done = 1'b0; 
  case(PC) 
  0: rom_inst = 8'b00000101; 
  1: rom_inst = 8'b00010100; 
  2: rom_inst = 8'b00100011; 
  3: rom_inst = 8'b00110010; 
  4: rom_inst = 8'b11011001; 
  5: rom_inst = 8'b11000100; 
  6: rom_inst = 8'b11101110; 
  7: rom_inst = 8'b11010011; 
  8: rom_inst = 8'b01000000; 
  9: rom_inst = 8'b10000100; 
  default: 
  begin 
  rom_done = 1'b1; 
  rom_inst = 8'b10000000; 
  end 
  endcase 
  end 
 endmodule