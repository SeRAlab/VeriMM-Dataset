module top_module(Clk, HiWrite, LoWrite, ALUOut, ALUControl, ALUResult, Hi, Lo, Out);input Clk, HiWrite, LoWrite, ALUOut;
    input [31:0] ALUResult, Hi, Lo;
    input [5:0] ALUControl;
    
    reg [31:0] Hi_r;
    reg [31:0] Lo_r;
    
    output reg [31:0] Out;
    
    always @(*) begin
        if (HiWrite == 1) Hi_r = Hi;
        if (LoWrite == 1) Lo_r = Lo;
        
        if (ALUOut == 1)
            Out = ALUResult;
        else if (ALUControl == 6'b010000) 
            Out = Hi_r;
        else if (ALUControl == 6'b011111) 
            Out = Lo_r;
        else
            Out = ALUResult;
        
    end
    

    
    
    
endmodule