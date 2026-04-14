module sram_cell (  
    input wire [3:0] data,  
    input wire we,  
    input wire re,  
    output reg [3:0] q  
);  
    always @(posedge we or posedge re) begin  
        if (we)  
            q <= data;  
        else if (re)  
            q <= q; // Maintain the current value if only reading  
    end  
endmodule