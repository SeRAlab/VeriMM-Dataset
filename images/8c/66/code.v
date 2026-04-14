module top_module(input[31:0] RotatorIn,input[4:0] RotatorBitNum,input[1:0] RotatorOp,output[31:0] RotatorOut);assign RotatorOut = 
  {32{RotatorOp==2'b00}} & (RotatorIn[31:0] << {1'b0,RotatorBitNum[4:0]}) | 
  {32{RotatorOp==2'b10}} & ({32'h0,RotatorIn[31:0]} >> {1'b0,RotatorBitNum[4:0]}) | 
  {32{RotatorOp==2'b11}} & ({{32{RotatorIn[31]}}, RotatorIn[31:0]} >> {1'b0,RotatorBitNum[4:0]}) ; 
 endmodule