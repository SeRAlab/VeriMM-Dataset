module sram_cell (  
    input wire D,      // Data input  
    input wire WE,     // Write Enable  
    input wire RE,     // Read Enable  
    output reg Q       // Data output  
);  
    always @(*) begin  
        if (WE) begin  
            Q <= D;  // Write data to SRAM cell  
        end else if (RE) begin  
            // Do nothing if read enable is active  
            // Q will reflect the stored data  
        end  
    end  
endmodule