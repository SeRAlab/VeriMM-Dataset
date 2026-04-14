module data_forwarding_unit(  
    input [4:0] EX_dest,  
    input [4:0] MEM_dest,  
    input [4:0] WB_dest,  
    input EX_valid,  
    input MEM_valid,  
    input WB_valid,  
    output reg ForwardA,  
    output reg ForwardB  
);  
    always @(*) begin  
        ForwardA = 0;  
        ForwardB = 0;  
        
        if (EX_valid && (EX_dest != 0)) begin  
            ForwardA = (EX_dest == WB_dest) ? 1 : ForwardA;  
        end  
        
        if (MEM_valid && (MEM_dest != 0)) begin  
            ForwardA = (MEM_dest == WB_dest) ? 1 : ForwardA;  
        end  
        
        if (EX_valid && (EX_dest != 0)) begin  
            ForwardB = (EX_dest == MEM_dest) ? 1 : ForwardB;  
        end  
        
        if (MEM_valid && (MEM_dest != 0)) begin  
            ForwardB = (MEM_dest == WB_dest) ? 1 : ForwardB;  
        end  
    end  
endmodule