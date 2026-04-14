module dram_cell (  
    input wire D,       // Data input  
    input wire RE,      // Read enable  
    input wire WE,      // Write enable  
    input wire CLK,     // Clock  
    output reg Q        // Data output  
);  

always @(posedge CLK) begin  
    if (WE) begin  
        Q <= D;         // Write operation  
    end  
end  

always @(posedge CLK) begin  
    if (RE) begin  
        // Read operation is just outputting Q, nothing needed here.  
    end  
end  

endmodule