module SRAM_Cell(  
    input clk,  
    input CE,  
    input WE,  
    input [7:0] D,  
    output reg [7:0] Q  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (CE) begin  
            if (WE) begin  
                memory <= D;  
            end  
            Q <= memory;  
        end  
    end  
endmodule