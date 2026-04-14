module dram_cell (  
    input clk,  
    input write_enable,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] storage;  

    always @(posedge clk) begin  
        if (write_enable) begin  
            storage <= data_in;  
        end  
        data_out <= storage;  
    end  
endmodule