module d_flip_flop (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] D,  
    output reg [3:0] Q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            Q <= 4'b0000;  
        end else begin  
            Q <= D;  
        end  
    end  
endmodule