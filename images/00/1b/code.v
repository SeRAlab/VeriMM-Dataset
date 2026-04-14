module sram_cell(  
    input wire D,        // Data input  
    input wire WE,      // Write Enable  
    input wire RE,      // Read Enable  
    output reg Q        // Data output  
);  
    always @(posedge WE or posedge RE) begin  
        if (WE) begin  
            Q <= D;      // Write data to SRAM cell  
        end  
    end  
    always @(posedge RE) begin  
        // Output the stored data when read is enabled  
        if (RE) begin  
            Q <= Q;      // Hold the current value  
        end  
    end  
endmodule