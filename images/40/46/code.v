module SRAM_Cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE) begin  
            Q <= D;  
        end else if (RE) begin  
            // Q is driven by the stored value  
            // No action needed as Q retains stored value  
        end  
    end  
endmodule