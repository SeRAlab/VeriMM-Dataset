module dram_cell(  
    input wire [3:0] D,  
    input wire WE,  
    input wire RE,  
    input wire CLK,  
    output reg [3:0] Q  
);  
    always @(posedge CLK) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  

    always @(posedge CLK) begin  
        if (RE) begin  
            // Do nothing, output holds the last written value  
        end  
    end  
endmodule