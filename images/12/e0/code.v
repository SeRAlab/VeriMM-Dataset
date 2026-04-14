module SRAM_Cell(  
    input [3:0] data,  
    input we,  
    input re,  
    output reg [3:0] q  
);  
    always @(posedge we or posedge re) begin  
        if (we)  
            q <= data;  
        else if (re)  
            q <= q;  
    end  
endmodule