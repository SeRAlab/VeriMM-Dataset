module sram_cell (  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    input wire RE,  
    input wire WE,  
    input wire CLK  
);  
    reg [15:0] memory;  

    always @(posedge CLK) begin  
        if (WE) begin  
            memory <= data_in;  
        end  
        if (RE) begin  
            data_out <= memory;  
        end  
    end  
endmodule