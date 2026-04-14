module sram_cell(  
    input wire D,  
    input wire WE,  
    output reg Q  
);  
    always @(WE or D) begin  
        if (WE)  
            Q <= D; // Write data to SRAM cell  
    end  
endmodule