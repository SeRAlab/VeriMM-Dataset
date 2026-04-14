module data_forwarding_unit(  
    input [4:0] src_reg1,  
    input [4:0] src_reg2,  
    input [4:0] dest_reg,  
    input reg_write,  
    output reg forward1,  
    output reg forward2  
);  
    always @(*) begin  
        forward1 = 0;  
        forward2 = 0;  
        
        if (reg_write) begin  
            if (src_reg1 == dest_reg) begin  
                forward1 = 1;  
            end  
            if (src_reg2 == dest_reg) begin  
                forward2 = 1;  
            end  
        end  
    end  
endmodule