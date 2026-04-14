module SRAM_16bit (  
    input [15:0] data_in,  
    output reg [15:0] data_out,  
    input we,  
    input [3:0] addr,  
    input clk  
);  
    reg [15:0] memory [15:0]; // 16 locations of 16 bits each  

    always @(posedge clk) begin  
        if (we)  
            memory[addr] <= data_in; // Write data to memory  
        else  
            data_out <= memory[addr]; // Read data from memory  
    end  
endmodule