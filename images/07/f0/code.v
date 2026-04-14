module SRAM_16bit (  
    input wire we,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16x16-bit memory  

    always @(posedge we) begin  
        memory[addr] <= data_in;  
    end  

    always @(negedge we) begin  
        data_out <= memory[addr];  
    end  
endmodule