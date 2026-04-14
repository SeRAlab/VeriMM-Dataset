module dram_cell (  
    input wire D,     // Data input  
    input wire WL,    // Word Line  
    input wire reset, // Reset signal  
    output reg Q      // Data output  
);  
    always @(posedge WL or posedge reset) begin  
        if (reset) begin  
            Q <= 0;  
        end else begin  
            Q <= D;  
        end  
    end  
endmodule