module dram_cell (  
    input clk,  
    input we,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (we)  
            memory <= data_in;  
        else  
            data_out <= memory;  
    end  
endmodule