module flash_memory_cell (  
    input wire clk,  
    input wire write_enable,  
    input wire read_enable,  
    input wire erase_enable,  
    input wire data_in,  
    output reg data_out  
);  
    reg stored_data;  

    always @(posedge clk) begin  
        if (erase_enable) begin  
            stored_data <= 1'b0;  
        end else if (write_enable) begin  
            stored_data <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read_enable) begin  
            data_out <= stored_data;  
        end  
    end  
endmodule