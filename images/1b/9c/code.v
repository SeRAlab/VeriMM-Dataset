module SRAM_8bit (  
    input wire clk,  
    input wire we, // Write enable  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory; // 8-bit memory cell  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in; // Write data  
        end  
        data_out <= memory; // Always output stored data  
    end  
endmodule