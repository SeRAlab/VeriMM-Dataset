module top_module(input A,input B,input C,input D,output reg F,output reg G,output reg H);reg [3:0] select; 
  always @ (A or B or C or D) 
  begin 
  select = {A, B, C, D}; 
  case(select) 
  4'b0000: begin 
  F = 1; 
  G = 0; 
  H = 1; 
  end 
  4'b0001: begin 
  F = 0; 
  G = 1; 
  H = 0; 
  end 
  4'b0010: begin 
  F = 1; 
  G = 0; 
  H = 0; 
  end 
  4'b0011: begin 
  F = 0; 
  G = 0; 
  H = 1; 
  end 
  4'b0100: begin 
  F = 0; 
  G = 1; 
  H = 1; 
  end 
  4'b0101: begin 
  F = 1; 
  G = 1; 
  H = 0; 
  end 
  4'b0110: begin 
  F = 0; 
  G = 0; 
  H = 0; 
  end 
  4'b0111: begin 
  F = 1; 
  G = 0; 
  H = 1; 
  end 
  4'b1000: begin 
  F = 1; 
  G = 1; 
  H = 0; 
  end 
  4'b1001: begin 
  F = 0; 
  G = 0; 
  H = 1; 
  end 
  4'b1010: begin 
  F = 1; 
  G = 0; 
  H = 0; 
  end 
  4'b1011: begin 
  F = 1; 
  G = 1; 
  H = 1; 
  end 
  4'b1100: begin 
  F = 0; 
  G = 0; 
  H = 0; 
  end 
  4'b1101: begin 
  F = 0; 
  G = 1; 
  H = 1; 
  end 
  4'b1110: begin 
  F = 1; 
  G = 1; 
  H = 1; 
  end 
  4'b1111: begin 
  F = 0; 
  G = 1; 
  H = 0; 
  end 
  endcase 
  end 
 endmodule