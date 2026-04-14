module SRAM_1bit (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    reg storage;  

    always @(posedge WE) begin  
        storage <= D;  
    end  

    always @(posedge RE) begin  
        Q <= storage;  
    end  
endmodule