module DRAM_Cell (  
    input wire [3:0] data,  
    input wire we,  
    input wire re,  
    input wire rst,  
    output reg [3:0] q  
);  
    always @(posedge we or posedge rst) begin  
        if (rst)  
            q <= 4'b0000;  
        else  
            q <= data;  
    end  
    
    always @(posedge re) begin  
        if (re)  
            q <= q;  // Maintain value on read enable  
    end  
endmodule