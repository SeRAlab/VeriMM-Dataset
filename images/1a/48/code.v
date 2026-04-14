module dram_cell(  
    input [7:0] data,  
    input we,  
    output reg [7:0] q  
);  
    always @(posedge we) begin  
        q <= data;  
    end  
endmodule