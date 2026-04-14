module dram_cell (  
    input wire D,      // Data input  
    input wire WE,     // Write enable  
    output reg Q       // Data output  
);  
    always @(posedge WE) begin  
        Q <= D;  
    end  
endmodule