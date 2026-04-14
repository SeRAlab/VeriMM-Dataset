module sram_cell (  
    input wire [3:0] data,  
    input wire we,  
    input wire re,  
    output reg [3:0] q  
);  
    always @(posedge we or posedge re) begin  
        if (we) begin  
            q <= data;  
        end else if (re) begin  
            // Output the data on read enable  
            // This is effectively a no-op in a typical SRAM design  
        end  
    end  
endmodule