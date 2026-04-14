module SRAM_Cell (  
    input wire [3:0] data,  
    input wire we,  
    output reg [3:0] q  
);  
    always @(posedge we) begin  
        if (we) begin  
            q <= data;  
        end  
    end  
endmodule