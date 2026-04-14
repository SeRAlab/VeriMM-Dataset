module dram_cell (  
    input wire clk,  
    input wire write_en,  
    input wire read_en,  
    input wire data_in,  
    output reg data_out  
);  

    reg storage;  

    always @(posedge clk) begin  
        if (write_en) begin  
            storage <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read_en) begin  
            data_out <= storage;  
        end  
    end  
endmodule