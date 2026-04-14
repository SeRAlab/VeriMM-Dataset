module sram_16bit (  
    input wire [15:0] data_in,  
    input wire [3:0] addr,  
    input wire read_enable,  
    input wire write_enable,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16 x 16-bit memory cells  

    always @(posedge write_enable) begin  
        if (write_enable)  
            memory[addr] <= data_in;  
    end  

    always @(posedge read_enable) begin  
        if (read_enable)  
            data_out <= memory[addr];  
    end  
endmodule