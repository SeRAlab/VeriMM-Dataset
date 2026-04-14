module dram_cell(  
    input wire D,  
    input wire RE,  
    input wire WE,  
    output reg Q  
);  
    always @ (posedge WE or posedge RE) begin  
        if (WE) begin  
            Q <= D;  
        end else if (RE) begin  
            // Do nothing, maintain Q's previous state  
        end  
    end  
endmodule