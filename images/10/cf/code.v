module sram_cell (  
    input wire [7:0] data_in,  
    input wire we,  
    input wire re,  
    output reg [7:0] data_out  
);  
    reg [7:0] sram;  
     
    always @(*) begin  
        if (we) begin  
            sram <= data_in;  
        end  
        if (re) begin  
            data_out <= sram;  
        end  
    end  
endmodule