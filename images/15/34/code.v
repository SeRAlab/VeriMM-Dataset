module SRAM_8bit (  
    input wire [7:0] data_in,  
    input wire read_enable,  
    input wire write_enable,  
    input wire [2:0] address,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8-bit memory with 8 locations  

    always @(posedge write_enable) begin  
        memory[address] <= data_in; // Write operation  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory[address]; // Read operation  
    end  
endmodule