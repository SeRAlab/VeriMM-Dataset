module sram_16bit (  
    input wire clk,  
    input wire [7:0] addr,  
    input wire [15:0] data_in,  
    input wire we,  
    input wire re,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:255];  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  
        end  
        if (re) begin  
            data_out <= memory[addr];  
        end  
    end  
endmodule