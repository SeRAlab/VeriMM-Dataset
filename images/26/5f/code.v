module sram_cell (  
    input wire [3:0] D,  
    input wire WE,  
    input wire RE,  
    output reg [3:0] Q  
);  
    reg [3:0] memory;  

    always @(posedge WE) begin  
        memory <= D;  
    end  

    always @(posedge RE) begin  
        Q <= memory;  
    end  
endmodule