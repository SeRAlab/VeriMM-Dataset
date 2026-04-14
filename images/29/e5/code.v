module SRAM_8bit (  
    input wire [7:0] D,  
    output reg [7:0] Q,  
    input wire WE,  
    input wire CLK  
);  
    always @(posedge CLK) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
endmodule