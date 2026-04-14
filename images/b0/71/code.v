module top_module(input[31:0] op1,input[31:0] op2,input[3:0] f,input en,output reg[31:0] result_hi,output reg[31:0] result_lo);always @(op1, op2, f) 
  if(en) begin 
  case (f) 
  0: begin 
  result_lo = $signed(op1) / $signed(op2); 
  result_hi = $signed(op1) % $signed(op2); 
  end 
  1: begin 
  result_lo = op1 / op2; 
  result_hi = op1 % op2; 
  end 
  2: begin 
  {result_hi, result_lo} = $signed(op1) * $signed(op2); 
  end 
  3: begin 
  {result_hi, result_lo} = op1 * op2; 
  end 
  endcase 
  $display("\tR[lo] = %x (hex)", result_lo); 
  $display("\tR[hi] = %x (hex)", result_hi); 
  end 
 endmodule