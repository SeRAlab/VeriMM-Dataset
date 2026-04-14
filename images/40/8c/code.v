module SRAM_4bit (  
    input wire [3:0] D,  // 4-bit Data Input  
    input wire WE,       // Write Enable  
    input wire RE,       // Read Enable  
    output reg [3:0] Q   // 4-bit Data Output  
);  
    reg [3:0] memory; // 4-bit memory storage  
  
    always @(posedge WE) begin  
        memory <= D; // Write data to memory  
    end  
  
    always @(posedge RE) begin  
        Q <= memory; // Read data from memory  
    end  
endmodule