module sram_cell (  
    input wire D,  
    input wire WE,  
    input wire SELECT,  
    input wire RESET,  
    output reg Q  
);  
    always @(posedge WE or posedge RESET) begin  
        if (RESET)  
            Q <= 1'b0;  
        else if (SELECT)  
            Q <= D;  
    end  
endmodule