module SRAM_Cell(  
    input [3:0] data_in,  
    input we,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge we) begin  
        memory <= data_in;  
    end  

    always @(negedge we) begin  
        data_out <= memory;  
    end  
endmodule