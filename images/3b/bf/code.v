module SRAM_Cell(  
    input [7:0] data_in,  
    input we,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  
  
    always @(posedge we) begin  
        memory <= data_in;  
    end  
  
    always @(*) begin  
        data_out = memory;  
    end  
endmodule