module sram_4bit (  
    input wire clk,  
    input wire write_enable,  
    input wire [3:0] data_in,  
    input wire [1:0] address,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [0:3]; // 4-bit SRAM with 4 addresses  

    always @(posedge clk) begin  
        if (write_enable)  
            memory[address] <= data_in; // Write data to memory  
        else  
            data_out <= memory[address]; // Read data from memory  
    end  
endmodule