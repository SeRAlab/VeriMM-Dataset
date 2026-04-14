module fir_filter(  
    input [4:0] x, // 5-bit input  
    output reg [5:0] y // 6-bit output  
);  
    always @(*) begin  
        y = (1 * x) + (2 * x) + (3 * x) + (2 * x) + (1 * x);  
    end  
endmodule