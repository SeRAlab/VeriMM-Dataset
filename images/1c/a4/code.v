module DRAM_Cell (  
    input wire D,  
    input wire WL,  
    output reg BL  
);  
    reg stored_data;  

    always @(posedge WL) begin  
        stored_data <= D;  
    end  

    always @(negedge WL) begin  
        BL <= stored_data;  
    end  
endmodule