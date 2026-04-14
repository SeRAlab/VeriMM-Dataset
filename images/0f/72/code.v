module iir_filter_4th_order (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] x,  
    output reg [15:0] y  
);  
    parameter [15:0] b0 = 16'h0001;  
    parameter [15:0] b1 = 16'h0002;  
    parameter [15:0] b2 = 16'h0001;  
    parameter [15:0] a1 = 16'hFFFF;  
    parameter [15:0] a2 = 16'hFFFE;  
    parameter [15:0] a3 = 16'hFFFD;  
    parameter [15:0] a4 = 16'hFFFC;  

    reg [15:0] x_reg [0:4];  
    reg [15:0] y_reg [0:4];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 16'b0;  
            x_reg[0] <= 16'b0;  
            x_reg[1] <= 16'b0;  
            x_reg[2] <= 16'b0;  
            x_reg[3] <= 16'b0;  
            x_reg[4] <= 16'b0;  
            y_reg[0] <= 16'b0;  
            y_reg[1] <= 16'b0;  
            y_reg[2] <= 16'b0;  
            y_reg[3] <= 16'b0;  
            y_reg[4] <= 16'b0;  
        end else begin  
            x_reg[0] <= x;  
            x_reg[1] <= x_reg[0];  
            x_reg[2] <= x_reg[1];  
            x_reg[3] <= x_reg[2];  
            x_reg[4] <= x_reg[3];  

            y_reg[0] <= (b0 * x_reg[0]) + (b1 * x_reg[1]) + (b2 * x_reg[2]) - (a1 * y_reg[1]) - (a2 * y_reg[2]) - (a3 * y_reg[3]) - (a4 * y_reg[4]);  
            y_reg[1] <= y_reg[0];  
            y_reg[2] <= y_reg[1];  
            y_reg[3] <= y_reg[2];  
            y_reg[4] <= y_reg[3];  
            y <= y_reg[0];  
        end  
    end  
endmodule