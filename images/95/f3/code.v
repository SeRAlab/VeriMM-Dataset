module top_module(clock, en, reset, op1, op2, out);input clock;		       
  input en;                    
  input reset;                 
  input [31:0] op1;            
  input [31:0] op2;            
  output reg [31:0] out;

  always @(posedge clock or negedge reset) begin
    if(reset == 0) begin
      out <= 0;
    end else begin
      out = op1 + op2;
    end
  end
	


endmodule