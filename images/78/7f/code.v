module top_module(clk, inA, inB, funct, zero, out);input wire clk;         
  input wire [31:0] inA;  
  input wire [31:0] inB;  
  input wire [2:0] funct; 

  output reg [31:0] out;  
  output wire zero;       

  always @(*) begin
    case (funct)
      3'b000 : out <= inA & inB; 
      3'b001 : out <= inA | inB; 
      3'b010 : out <= inA + inB; 
      3'b110 : out <= inA - inB; 
    endcase
  end

  assign zero = (out==0) ? 1:0;   

endmodule