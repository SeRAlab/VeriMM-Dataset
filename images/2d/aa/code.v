module data_forwarding_unit(  
    input [4:0] EX_dst,  
    input [4:0] ID_src1,  
    input [4:0] ID_src2,  
    output reg ForwardA,  
    output reg ForwardB  
);  
    always @(*) begin  
        ForwardA = (EX_dst != 0) && (EX_dst == ID_src1);  
        ForwardB = (EX_dst != 0) && (EX_dst == ID_src2);  
    end  
endmodule