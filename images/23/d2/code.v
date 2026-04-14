module SRAM_Cell (  
    input wire [3:0] data_in,  
    output reg [3:0] data_out,  
    input wire we,  
    input wire clk  
);  
    reg [3:0] memory;  
    
    always @(posedge clk) begin  
        if (we)  
            memory <= data_in;  
    end  
    
    always @(*) begin  
        data_out = memory;  
    end  
endmodule