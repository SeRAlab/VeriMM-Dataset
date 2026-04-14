module pipeline_processor (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] A,  
    input wire [7:0] B,  
    output reg [15:0] C  
);  
    reg [7:0] sum;  
    reg [15:0] product;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sum <= 0;  
            product <= 0;  
            C <= 0;  
        end else begin  
            sum <= A + B;  
            product <= sum * 2;  
            C <= product;  
        end  
    end  
endmodule