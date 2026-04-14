module flash_memory_cell(  
    input wire program,  
    input wire erase,  
    input wire clk,  
    output reg data_out  
);  
    always @(posedge clk) begin  
        if (erase)  
            data_out <= 1'b0;  
        else if (program)  
            data_out <= 1'b1;  
    end  
endmodule