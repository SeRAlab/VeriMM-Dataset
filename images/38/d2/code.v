module sram_cell(input wire clk,  
                  input wire write_en,  
                  input wire read_en,  
                  input wire [15:0] data_in,  
                  output reg [15:0] data_out);  

    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (write_en)  
            memory <= data_in;  
    end  

    always @(posedge clk) begin  
        if (read_en)  
            data_out <= memory;  
    end  
endmodule