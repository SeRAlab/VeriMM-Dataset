module dram_cell (  
    input wire [3:0] D,  
    input wire WE,  
    output reg [3:0] Q  
);  
    always @(WE or D) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
endmodule