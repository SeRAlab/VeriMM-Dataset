module dram_cell (  
    input wire clk,  
    input wire wr_enable,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] mem [0:15]; // 16 entries of 16-bit memory  

    always @(posedge clk) begin  
        if (wr_enable) begin  
            mem[addr] <= data_in;  
        end  
        data_out <= mem[addr];  
    end  
endmodule