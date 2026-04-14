module dram_cell (  
    input wire D,  
    input wire WE,  
    input wire CLK,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (WE)  
            Q <= D;  
    end  
endmodule