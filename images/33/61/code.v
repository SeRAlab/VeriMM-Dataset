module SRAM_Cell (  
    input wire [7:0] data,  
    input wire we,  
    input wire re,  
    output reg [7:0] q  
);  
    reg [7:0] memory;  

    always @(posedge we) begin  
        memory <= data;  
    end  

    always @(posedge re) begin  
        q <= memory;  
    end  
endmodule