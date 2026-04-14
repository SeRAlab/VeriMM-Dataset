module dram_cell(  
    input wire [3:0] DIN,  
    output reg [3:0] DOUT,  
    input wire READ,  
    input wire WRITE,  
    input wire CLK  
);  
    reg [3:0] memory;  
   
    always @(posedge CLK) begin  
        if (WRITE) begin  
            memory <= DIN;  
        end  
        if (READ) begin  
            DOUT <= memory;  
        end  
    end  
endmodule