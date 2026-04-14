module dram_cell(  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [15:0] din,  
    output reg [15:0] dout  
);  
    reg [15:0] mem;  

    always @(posedge clk) begin  
        if (we) begin  
            mem <= din;  
        end  
        if (re) begin  
            dout <= mem;  
        end  
    end  
endmodule