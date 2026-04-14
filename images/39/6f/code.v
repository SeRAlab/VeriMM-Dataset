module sram_cell (  
    input wire clk,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    input wire we, // write enable  
    input wire re  // read enable  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (we)  
            memory <= data_in;  
        if (re)  
            data_out <= memory;  
    end  
endmodule