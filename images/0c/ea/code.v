module SRAM_8bit (  
    input wire [7:0] data_in,  
    input wire we,  
    input wire re,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge we) begin  
        memory <= data_in;  
    end  

    always @(posedge re) begin  
        data_out <= memory;  
    end  
endmodule