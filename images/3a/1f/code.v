module SRAM_4bit(  
    input wire [3:0] D,  
    input wire WE,  
    input wire RE,  
    input wire clk,  
    output reg [3:0] Q  
);  
    always @(posedge clk) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
    
    always @(posedge clk) begin  
        if (RE) begin  
            // Output Q is already driven by the register  
        end  
    end  
endmodule