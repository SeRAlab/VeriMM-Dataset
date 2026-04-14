module dram_cell (  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [3:0] d,  
    output reg [3:0] q  
);  
    always @(posedge clk) begin  
        if (we) begin  
            q <= d;  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            // Reading is implied by the output q  
        end  
    end  
endmodule