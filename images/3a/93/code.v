module dram_cell (  
    input wire [7:0] data_in,  
    input wire write_enable,  
    output reg [7:0] data_out  
);  
    // Memory to hold the 8-bit value  
    reg [7:0] memory;  
    
    always @(posedge write_enable) begin  
        memory <= data_in;  
    end  
    
    always @(*) begin  
        data_out = memory;  
    end  
endmodule