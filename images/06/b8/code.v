module dram_cell (  
    input [3:0] data,  
    input RE,  
    input WE,  
    input clk,  
    output reg [3:0] q  
);  
    always @(posedge clk) begin  
        if (WE) begin  
            q <= data;  
        end else if (RE) begin  
            q <= q; // maintain the value on read  
        end  
    end  
endmodule