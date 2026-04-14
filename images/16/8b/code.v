module dram_cell (  
    input wire [15:0] din,  
    input wire read_en,  
    input wire write_en,  
    output reg [15:0] dout  
);  
    reg [15:0] memory;  

    always @(posedge write_en) begin  
        memory <= din;  
    end  

    always @(posedge read_en) begin  
        dout <= memory;  
    end  
endmodule