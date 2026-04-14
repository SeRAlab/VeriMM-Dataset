module dram_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    output reg Q  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE)  
            Q <= D;  
    end  
    always @(posedge RE) begin  
        if (RE && !WE)  
            Q <= Q;  
    end  
endmodule