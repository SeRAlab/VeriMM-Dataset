module flash_memory_cell (  
    input wire clk,  
    input wire ctrl,  
    input wire data_in,  
    output reg data_out  
);  
    always @(posedge clk) begin  
        if (ctrl) begin  
            data_out <= data_in;  
        end  
    end  
endmodule