module data_forwarding_unit(  
    input [4:0] src1,  
    input [4:0] src2,  
    input [4:0] dest,  
    input valid,  
    output reg forward_src1,  
    output reg forward_src2  
);  
    always @(*) begin  
        forward_src1 = 0;  
        forward_src2 = 0;  
        if (valid) begin  
            if (dest == src1)  
                forward_src1 = 1;  
            if (dest == src2)  
                forward_src2 = 1;  
        end  
    end  
endmodule