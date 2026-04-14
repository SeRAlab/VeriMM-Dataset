module sram_cell(  
    input [3:0] data,  
    input we,  
    output reg [3:0] q  
);  
    always @(we or data) begin  
        if (we) begin  
            q <= data;  
        end  
    end  
endmodule