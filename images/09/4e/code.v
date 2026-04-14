module sram_cell (  
    input wire [7:0] data,  
    input wire we,  
    input wire re,  
    output reg [7:0] out  
);  
    reg [7:0] storage;  
  
    always @(*) begin  
        if (we) begin  
            storage <= data;  
        end  
    end  
  
    always @(*) begin  
        if (re) begin  
            out <= storage;  
        end  
    end  
endmodule