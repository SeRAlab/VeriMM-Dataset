module position_tracker (  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire [15:0] x_in,  
    input wire [15:0] y_in,  
    output reg [15:0] x_out,  
    output reg [15:0] y_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_out <= 16'b0;  
            y_out <= 16'b0;  
        end else if (enable) begin  
            x_out <= x_in;  
            y_out <= y_in;  
        end  
    end  
endmodule