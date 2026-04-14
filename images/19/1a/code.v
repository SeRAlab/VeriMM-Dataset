module dram_cell (  
    input wire clk,  
    input wire write_enable,  
    input wire [3:0] address,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16 x 16-bit memory cells  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
        data_out <= memory[address];  
    end  
endmodule