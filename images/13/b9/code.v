module sram_cell (  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    input wire write_enable,  
    input wire [3:0] addr,  
    input wire clk  
);  
    reg [15:0] memory [15:0]; // 16 cells of 16 bits each  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[addr] <= data_in;  
        end  
        data_out <= memory[addr];  
    end  
endmodule