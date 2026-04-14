module sram_cell (  
    input [7:0] D,  
    input [2:0] A,  
    input WE,  
    output reg [7:0] Q  
);  
    reg [7:0] memory [0:7]; // 8-bit SRAM with 8 addresses  

    always @(WE or D or A) begin  
        if (WE) begin  
            memory[A] <= D; // Write data to SRAM  
        end else begin  
            Q <= memory[A]; // Read data from SRAM  
        end  
    end  
endmodule