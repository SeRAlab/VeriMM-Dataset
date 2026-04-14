module data_forwarding_unit(  
    input [4:0] src_reg1, // Source Register 1  
    input [4:0] src_reg2, // Source Register 2  
    input [4:0] dest_reg1, // Destination Register 1  
    input [4:0] dest_reg2, // Destination Register 2  
    input reg_write1, // Write enable for Register 1  
    input reg_write2, // Write enable for Register 2  
    output reg forward_a, // Forwarding signal for src_reg1  
    output reg forward_b  // Forwarding signal for src_reg2  
);  
    always @(*) begin  
        // Default to no forwarding  
        forward_a = 0;  
        forward_b = 0;  

        // Forwarding for src_reg1  
        if (reg_write1 && (src_reg1 == dest_reg1)) begin  
            forward_a = 1;  
        end  
        
        // Forwarding for src_reg2  
        if (reg_write2 && (src_reg2 == dest_reg2)) begin  
            forward_b = 1;  
        end  
    end  
endmodule