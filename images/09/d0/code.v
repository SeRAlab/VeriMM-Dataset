module dram_cell (  
    input wire [15:0] data_in,  
    input wire rw,  
    input wire clk,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (rw)  
            memory <= data_in;  
        else  
            data_out <= memory;  
    end  
endmodule