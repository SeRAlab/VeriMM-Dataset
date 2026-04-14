module sram_cell(  
    input wire WE,   // Write Enable  
    input wire RE,   // Read Enable  
    input wire D,    // Data Input  
    output reg Q     // Data Output  
);  
    always @(*) begin  
        if (WE) begin  
            Q <= D;  // Write data to SRAM cell  
        end  
    end  

    always @(*) begin  
        if (RE) begin  
            Q <= Q;  // Output the stored value  
        end  
    end  
endmodule