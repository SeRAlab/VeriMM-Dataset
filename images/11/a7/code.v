module dram_cell(clk, we, addr, din, dout);  
    input clk;  
    input we;  
    input [1:0] addr;  
    input [3:0] din;  
    output reg [3:0] dout;  

    reg [3:0] memory [0:3];  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= din;  
        end  
        dout <= memory[addr];  
    end  
endmodule