module dram_cell (  
    input wire [15:0] data_in,  
    input wire RE,  
    input wire WE,  
    input wire clk,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  
    
    always @(posedge clk) begin  
        if (WE) begin  
            memory <= data_in;  
        end  
    end  
    
    always @(posedge clk) begin  
        if (RE) begin  
            data_out <= memory;  
        end  
    end  
endmodule