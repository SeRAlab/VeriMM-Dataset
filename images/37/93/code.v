module sram_cell(  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire data_in,  
    output reg data_out  
);  
    reg storage;  

    always @(posedge clk) begin  
        if (we) begin  
            storage <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            data_out <= storage;  
        end  
    end  
endmodule