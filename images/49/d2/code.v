module top_module(
  input [63:0]a, b,
  input [3:0] ALUOp,
  output reg [63:0]  Result, 
  output Zero
);always @ (a or b or ALUOp)
    begin
      case (ALUOp)
        4'b0000: Result = a & b;    
        4'b0001: Result = a | b;    
        4'b0010: Result = a + b;    
        4'b0110: Result = a - b;    
        4'b1100: Result = ~(a | b); 
      endcase
    end
  	assign Zero = Result ? 1'b0 : 1'b1;  
    
endmodule