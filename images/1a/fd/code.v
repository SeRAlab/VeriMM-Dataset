module dram_cell(  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
    always @(posedge RE) begin  
        if (RE) begin  
            // output the stored data Q, no action needed since it's already output  
        end  
    end  
endmodule