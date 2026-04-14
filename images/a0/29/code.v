module top_module(NPC,PCWr,clk,rst,PC);input   [31:2]   NPC ;
    input            PCWr ;
    input            clk, rst ;
    output  [31:2]   PC ;   
    
    reg   [31:2]   PC ;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
           PC <= 30'h0c00 ;
        else if (PCWr) 
           PC <= NPC ;
    end
    
endmodule