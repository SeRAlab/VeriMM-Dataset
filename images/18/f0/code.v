module dram_cell (  
    input wire clk,  
    input wire we,       // write enable  
    input wire re,       // read enable  
    input wire [7:0] din,// data input  
    output reg [7:0] dout // data output  
);  
    reg [7:0] data; // internal storage  

    always @(posedge clk) begin  
        if (we)  
            data <= din; // write data on clock's rising edge  
    end  

    always @(posedge clk) begin  
        if (re)  
            dout <= data; // output data on clock's rising edge  
    end  
endmodule