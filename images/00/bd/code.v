module flash_memory_cell (  
    input clk,  
    input prog,  
    input erase,  
    input read,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (erase) begin  
            memory <= 8'b00000000;  
        end else if (prog) begin  
            memory <= data_in;  
        end else if (read) begin  
            data_out <= memory;  
        end  
    end  
endmodule