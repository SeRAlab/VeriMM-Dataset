module dram_cell (  
    input clk,  
    input we,  
    input d,  
    output reg q  
);  
    always @(posedge clk) begin  
        if (we)  
            q <= d;  
    end  
endmodule