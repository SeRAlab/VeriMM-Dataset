module dram_cell (  
    input wire clk,  
    input wire write_enable,  
    input wire read_enable,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (write_enable)  
            memory <= data_in;  
    end  

    always @(posedge clk) begin  
        if (read_enable)  
            data_out <= memory;  
    end  
endmodule