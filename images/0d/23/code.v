module sram_cell (  
    input [3:0] data,  
    input we,  
    output reg [3:0] q  
);  
    always @(posedge we) begin  
        q <= data;  
    end  
endmodule