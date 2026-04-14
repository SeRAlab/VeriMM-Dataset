module flash_memory_cell (  
    input wire clk,  
    input wire control,  
    input wire data_in,  
    output reg data_out  
);  
    reg memory;  

    always @(posedge clk) begin  
        if (control) begin  
            memory <= data_in;  
        end  
        else begin  
            data_out <= memory;  
        end  
    end  
endmodule