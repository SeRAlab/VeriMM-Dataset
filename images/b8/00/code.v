module top_module(
  input wire[15:0] in1, in2,
  input wire[2:0]alu_op,  
  output reg[15:0] Z
);always@* begin
    if(alu_op==3'b001) 
      Z = in1+in2;
    else if(alu_op==3'b010) 
      Z = in1;
    else
      Z = 1'bX;
  end

endmodule