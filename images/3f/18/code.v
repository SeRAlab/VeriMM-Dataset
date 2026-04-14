module dram_cell (  
    input wire clk,  
    input wire we, // write enable  
    input wire re, // read enable  
    input wire [7:0] din, // data input  
    output reg [7:0] dout // data output  
);  
    reg [7:0] mem; // internal memory for data  

    always @(posedge clk) begin  
        if (we) begin  
            mem <= din; // write data to memory  
        end  
        if (re) begin  
            dout <= mem; // read data from memory  
        end  
    end  
endmodule