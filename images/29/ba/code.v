module SRAM_8bit (  
    input wire WE,        // Write enable  
    input wire CE,        // Chip enable  
    input wire [2:0] addr, // Address (3 bits for 8 locations)  
    input wire [7:0] D,   // Data input (8 bits)  
    output reg [7:0] Q    // Data output (8 bits)  
);  
    reg [7:0] memory [0:7]; // 8 x 8-bit SRAM memory  

    always @(negedge CE) begin  
        if (!WE) begin  
            memory[addr] <= D; // Write data  
        end else begin  
            Q <= memory[addr]; // Read data  
        end  
    end  
endmodule