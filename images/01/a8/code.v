module sram_1bit (  
    input wire data,  
    input wire we,  
    input wire clk,  
    output reg q  
);  
    always @(posedge clk) begin  
        if (we)  
            q <= data;  
    end  
endmodule