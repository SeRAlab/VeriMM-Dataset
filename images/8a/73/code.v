module top_module(
  input      [15:0] a,
  input      [15:0] b,
  input      [3:0]  cmd,
  output reg [15:0] rLeft,
  output reg [15:0] rRight,
  output zero
);always@(a, b, cmd) begin
    case(cmd) 
      
       
      1: rRight = a + b;
      
      2: rRight = a - b;
      
      3: rRight = a & b;
      
      4: rRight = a | b;
      
      5: rRight = a ^ b;
      
      6: begin rRight[15:1] = a[14:0]; rRight[0]=  a[0]; end
      
      7: begin rRight[14:0] = a[15:1]; rRight[15] = a[15]; end
      
      8: rRight = {1'b0, a[15:1] };
      
      9: begin {rLeft, rRight} = a * b; end
    endcase    
  end   

  assign zero = (rLeft == 0 && rRight == 0)?1:0;
  
endmodule