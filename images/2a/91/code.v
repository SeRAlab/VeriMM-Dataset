module SRAM_Cell (  
    input wire [15:0] D,  
    output reg [15:0] Q,  
    input wire WE,  
    input wire RE,  
    input wire CLK  
);  
    reg [15:0] memory;  

    always @(posedge CLK) begin  
        if (WE) begin  
            memory <= D;  
        end  
        if (RE) begin  
            Q <= memory;  
        end  
    end  
endmodule