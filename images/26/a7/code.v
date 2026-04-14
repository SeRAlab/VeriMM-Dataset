module dram_cell (  
    input wire clk,  
    input wire enable,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (enable) begin  
            memory <= data_in;  // Write data on enable high  
        end  
        else begin  
            data_out <= memory;  // Read data on enable low  
        end  
    end  
endmodule