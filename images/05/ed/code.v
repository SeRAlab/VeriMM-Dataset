module dram_cell (  
    input wire [15:0] data_in,  
    input wire read_en,  
    input wire write_en,  
    output reg [15:0] data_out  
);  

reg [15:0] memory;  

always @(*) begin  
    if (write_en) begin  
        memory <= data_in;  
    end  
    if (read_en) begin  
        data_out <= memory;  
    end  
end  
endmodule