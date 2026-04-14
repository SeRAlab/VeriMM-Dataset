module sram_4bit (  
    input wire [3:0] data_in,  
    input wire write_enable,  
    input wire [1:0] addr,  
    input wire clk,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [0:3]; // 4-bit memory with 4 addresses  
    
    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[addr] <= data_in;  
        end  
        data_out <= memory[addr];  
    end  
endmodule