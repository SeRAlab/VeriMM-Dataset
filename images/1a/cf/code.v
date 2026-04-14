module dram_cell (  
    input wire data,  
    input wire read,  
    input wire write,  
    output reg q  
);  
    reg stored_bit;  
    
    always @(posedge write) begin  
        stored_bit <= data;  
    end  
    
    always @(posedge read) begin  
        q <= stored_bit;  
    end  
endmodule