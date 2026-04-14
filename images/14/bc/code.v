module d_flip_flop (  
    input wire clk,  
    input wire clk_en,  
    input wire rst,  
    input wire [3:0] d,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            q <= 4'b0000;  
        else if (clk_en)  
            q <= d;  
    end  
endmodule