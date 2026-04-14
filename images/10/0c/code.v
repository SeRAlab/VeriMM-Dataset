module SRAM_8bit(  
    input wire [7:0] data_in,  
    input wire we,  
    input wire clk,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (we)  
            memory <= data_in;  
    end  

    always @(negedge clk) begin  
        if (!we)  
            data_out <= memory;  
    end  
endmodule