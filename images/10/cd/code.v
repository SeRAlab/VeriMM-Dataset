module SRAM_Cell (  
    input [15:0] D,  
    input WE,  
    input [3:0] A,  
    output reg [15:0] Q  
);  
    reg [15:0] memory [15:0]; // 16-bit SRAM with 16 locations  

    always @(posedge WE) begin  
        memory[A] <= D; // Write data to memory at address A  
    end  

    always @(negedge WE) begin  
        Q <= memory[A]; // Read data from memory at address A  
    end  
endmodule