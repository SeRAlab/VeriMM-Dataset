module top_module(clock,WB,Memout,ALUOut,RegRD,WBreg,Memreg,ALUreg,RegRDreg);input clock; 
   input  [1:0]WB; 
   input [4:0] RegRD; 
   input [31:0] Memout,ALUOut; 
   output reg [1:0] WBreg; 
   output reg [31:0] Memreg,ALUreg; 
   output reg [4:0] RegRDreg;
    
    always@(posedge clock) 
    begin 
        WBreg <= WB; 
        Memreg <= Memout; 
        ALUreg <= ALUOut; 
        RegRDreg <= RegRD; 
    end 
    
endmodule