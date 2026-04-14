module SRAM_cell(  
    input wire WE,     // Write Enable  
    input wire RE,     // Read Enable  
    input wire D,      // Data Input  
    output reg Q       // Data Output  
);  
    always @(*) begin  
        if (WE) begin  
            Q <= D;      // Write data to SRAM cell  
        end else if (RE) begin  
            Q <= Q;      // Read data from SRAM cell (hold current value)  
        end  
    end  
endmodule