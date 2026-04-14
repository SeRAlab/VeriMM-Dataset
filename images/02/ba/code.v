module dram_cell (  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [3:0] d_in,  
    output reg [3:0] d_out  
);  
    reg [3:0] memory;  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= d_in;  
        end  
        if (re) begin  
            d_out <= memory;  
        end  
    end  
endmodule