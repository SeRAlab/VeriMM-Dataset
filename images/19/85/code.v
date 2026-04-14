module SRAM_1bit (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    reg stored_bit;  

    always @(posedge WE) begin  
        stored_bit <= D;  
    end  

    always @(posedge RE) begin  
        Q <= stored_bit;  
    end  
endmodule