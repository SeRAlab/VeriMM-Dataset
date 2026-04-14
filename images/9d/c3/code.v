module top_module(input0, input1, select, out);input [31:0] input0, input1;   
  input select;              	 
  output reg [31:0] out;         
  

  

  always @ (select or input0 or input1)
  begin
    case(select)
      
      1'b0: begin
        
        out <= input0;
      end
      
      1'b1: begin
        
        out <= input1;
      end
    endcase
  end
endmodule