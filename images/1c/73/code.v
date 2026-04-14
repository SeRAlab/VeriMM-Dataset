module dram_cell(  
    input [7:0] data_in,  
    input we,  
    input re,  
    input clk,  
    output reg [7:0] data_out  
);  
    reg [7:0] storage;  

    always @(posedge clk) begin  
        if (we) begin  
            storage <= data_in;  
        end  
        if (re) begin  
            data_out <= storage;  
        end  
    end  
endmodule