module sram_cell(  
    input wire [3:0] data_in,  
    input wire write_enable,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge write_enable) begin  
        memory <= data_in;  
    end  

    always @(*) begin  
        data_out = memory;  
    end  
endmodule