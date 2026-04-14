module SRAM_Cell (  
    input wire [15:0] data_in,  
    input wire word_line,  
    input wire write_enable,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge word_line) begin  
        if (write_enable)  
            memory <= data_in;  
        else  
            data_out <= memory;  
    end  
endmodule