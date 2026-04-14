module SRAM_Cell (  
    input wire [7:0] data_in,  
    input wire write_enable,  
    input wire clk,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (write_enable)  
            memory <= data_in;  
        else  
            data_out <= memory;  
    end  
endmodule