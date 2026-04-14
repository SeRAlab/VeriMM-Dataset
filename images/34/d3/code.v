module dram_cell (  
    input wire clk,  
    input wire WE,  
    input wire RE,  
    input wire [7:0] D,  
    input wire [2:0] A,  
    output reg [7:0] Q  
);  
    reg [7:0] memory [7:0]; // 8-bit DRAM with 8 cells  
  
    always @(posedge clk) begin  
        if (WE) begin  
            memory[A] <= D; // Write data to the selected address  
        end  
        if (RE) begin  
            Q <= memory[A]; // Read data from the selected address  
        end  
    end  
endmodule