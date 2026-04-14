module sram_cell (  
    input [3:0] data_in,  
    input we,  
    input clk,  
    output reg [3:0] data_out  
);  

    always @(posedge clk) begin  
        if (we) begin  
            data_out <= data_in;  
        end  
    end  
endmodule