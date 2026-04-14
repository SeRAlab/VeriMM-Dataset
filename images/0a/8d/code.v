module dram_4bit (  
    input wire write_enable,  
    input wire clock,  
    input wire [3:0] data_in,  
    input wire [1:0] address,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [3:0]; // 4x4-bit memory  

    always @(posedge clock) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
    end  

    always @(negedge clock) begin  
        data_out <= memory[address];  
    end  
endmodule