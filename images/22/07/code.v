module sram_cell(  
    input wire clk,  
    input wire write_enable,  
    input wire data_in,  
    output reg data_out  
);  
    reg storage;  

    always @(posedge clk) begin  
        if (write_enable) begin  
            storage <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        data_out <= storage;  
    end  
endmodule