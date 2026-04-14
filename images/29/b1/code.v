module flash_memory_cell (  
    input clk,  
    input enable,  
    input write_data,  
    input read,  
    output reg stored_data  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            stored_data <= write_data;  
        end  
    end  
    always @(posedge clk) begin  
        if (read) begin  
            stored_data <= stored_data;  
        end  
    end  
endmodule