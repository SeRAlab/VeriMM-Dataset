module sram_cell (  
    input wire WE,  
    input wire RE,  
    input wire D,  
    output reg Q  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
    always @(posedge RE) begin  
        if (RE) begin  
            // Q remains unchanged if WE is low  
        end  
    end  
endmodule