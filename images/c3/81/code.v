module adder(
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] sum
);

   parameter INITVAL = 0;
   integer globali;

   initial globali = INITVAL;

   always @(*) begin
      sum = A + B;
   end
   
   function [31:0] getName;  
      input fake;  
      getName = "gmod"; 
   endfunction
   
   function [31:0] getGlob;  
      input fake;  
      getGlob = globali;  
   endfunction
   
endmodule