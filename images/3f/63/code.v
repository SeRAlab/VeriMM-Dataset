module dram_cell (  
    input wire clk,  
    input wire wen,  
    input wire ren,  
    input wire din,  
    output reg dout  
);  
    reg stored_bit;  

    always @(posedge clk) begin  
        if (wen) begin  
            stored_bit <= din;  
        end  
    end  

    always @(posedge clk) begin  
        if (ren) begin  
            dout <= stored_bit;  
        end  
    end  
endmodule