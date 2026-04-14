module SRAM_16bit (  
    input [15:0] din,  
    input read_en,  
    input write_en,  
    input clk,  
    output reg [15:0] dout  
);  

    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (write_en) begin  
            memory <= din;  
        end  
    end  

    always @(posedge clk) begin  
        if (read_en) begin  
            dout <= memory;  
        end  
    end  
endmodule