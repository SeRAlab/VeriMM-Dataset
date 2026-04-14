module dram_cell (  
    input wire CLK,  
    input wire WE,  
    input wire RE,  
    input wire [3:0] D,  
    output reg [3:0] Q  
);  

    reg [3:0] storage;  

    always @(posedge CLK) begin  
        if (WE) begin  
            storage <= D;  
        end  
    end  

    always @(posedge CLK) begin  
        if (RE) begin  
            Q <= storage;  
        end  
    end  
endmodule