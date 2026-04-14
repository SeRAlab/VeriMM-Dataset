module dram_cell (  
    input wire [7:0] D,  
    input wire WE,  
    input wire RE,  
    input wire CLK,  
    output reg [7:0] Q  
);  
    reg [7:0] storage;  

    always @(posedge CLK) begin  
        if (WE) begin  
            storage <= D;  
        end  
        if (RE) begin  
            Q <= storage;  
        end  
    end  
endmodule