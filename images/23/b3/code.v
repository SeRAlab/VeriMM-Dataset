module SRAM_1bit (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    reg storage;  

    always @(posedge WE or negedge WE) begin  
        if (WE) begin  
            storage <= D;  
        end  
    end  

    always @(posedge RE or negedge RE) begin  
        if (RE) begin  
            Q <= storage;  
        end  
    end  
endmodule