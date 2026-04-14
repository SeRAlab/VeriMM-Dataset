module sram_cell (  
    input clk,  
    input we, // write enable  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory; // 8-bit SRAM cell  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in; // Write data to memory  
        end  
        data_out <= memory; // Always output the current memory value  
    end  
endmodule