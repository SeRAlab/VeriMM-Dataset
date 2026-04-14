module sram_cell (  
    input wire clk,  
    input wire EN,  
    input wire [7:0] D,  
    input wire WL,  
    output reg [7:0] Q  
);  
    reg [7:0] memory;  
    
    always @(posedge clk) begin  
        if (EN) begin  
            if (WL) begin  
                memory <= D; // Write operation  
            end  
            Q <= memory; // Read operation  
        end  
    end  
endmodule