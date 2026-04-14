module top_module(
    MEMWBRegWrite_i, 
    EXMEMRegWrite_i, 
    MEMforward_i, 
    EXMEMforward_i, 
    IDEX1_i,
    IDEX2_i,
    MUXup_o,
    MUXdown_o
);input [4:0] IDEX1_i,IDEX2_i,MEMforward_i, EXMEMforward_i;
input MEMWBRegWrite_i,EXMEMRegWrite_i;
output [1:0] MUXup_o,MUXdown_o;
reg [1:0] MUXup_o,MUXdown_o;



    
    always @*
    begin
        if((EXMEMRegWrite_i) &&(EXMEMforward_i!=1'b0) &&(EXMEMforward_i == IDEX1_i) )
            MUXup_o <= 2'b10;
        else if((MEMWBRegWrite_i) && (MEMforward_i!=1'b0) &&(MEMforward_i == IDEX1_i))
            MUXup_o <= 2'b01;
        else
            MUXup_o <= 2'b00;
    

    
    
        if((EXMEMRegWrite_i) &&(EXMEMforward_i!=1'b0) &&(EXMEMforward_i == IDEX2_i) )
            MUXdown_o <= 2'b10;
        else if((MEMWBRegWrite_i) && (MEMforward_i!=1'b0) &&(MEMforward_i == IDEX2_i))
            MUXdown_o <= 2'b01;
        else
            MUXdown_o <= 2'b00;
    end
endmodule