module top_module(
    ID_EX_MemRead, EX_MEM_MemRead, EX_Rd, ID_Rs, ID_Rt, EX_MEM_Rd, PCSrc, Stall
    );input ID_EX_MemRead;
    input EX_MEM_MemRead;
    input [4:0] EX_Rd;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
    input [4:0] EX_MEM_Rd;
    input [2:0] PCSrc;
    output Stall;
    
    wire EX_Stall, MEM_Stall;
    
    assign EX_Stall = (ID_EX_MemRead) && (EX_Rd != 5'b00000)&& ((EX_Rd == ID_Rs) || (EX_Rd == ID_Rt));
    assign MEM_Stall = (EX_MEM_MemRead) && (EX_MEM_Rd != 5'b00000) && (EX_MEM_Rd == ID_Rs);
    assign Stall = EX_Stall || (PCSrc == 3'b010 && MEM_Stall); 
    
endmodule