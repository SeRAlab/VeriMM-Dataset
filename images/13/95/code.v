module SRAM_4bit (  
    input [3:0] data_in,  
    input read_en,  
    input write_en,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge write_en) begin  
        if (write_en) begin  
            memory <= data_in;  
        end  
    end  

    always @(posedge read_en) begin  
        if (read_en) begin  
            data_out <= memory;  
        end  
    end  
endmodule