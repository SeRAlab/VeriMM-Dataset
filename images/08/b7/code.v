module sram_cell (  
    input wire [7:0] data,  
    input wire we,  
    input wire re,  
    output reg [7:0] q  
);  
    always @(posedge we or posedge re) begin  
        if (we)  
            q <= data;  
        else if (re)  
            q <= q;  
    end  
endmodule