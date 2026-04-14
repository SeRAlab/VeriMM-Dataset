module SRAM_4bit(  
    input wire [3:0] data_in,  
    input wire enable,  
    input wire clk,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge clk) begin  
        if (enable)  
            memory <= data_in;  
    end  

    always @(posedge clk) begin  
        if (!enable)  
            data_out <= memory;  
    end  
endmodule