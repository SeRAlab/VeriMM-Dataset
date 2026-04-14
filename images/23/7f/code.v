module ecc_point_addition (  
    input clk,  
    input rst,  
    input [31:0] x1,  
    input [31:0] y1,  
    input [31:0] x2,  
    input [31:0] y2,  
    input [31:0] p,  
    output reg [31:0] x3,  
    output reg [31:0] y3,  
    output reg done  
);  
    reg [31:0] m;  
    reg [31:0] x_diff, y_diff;  
    reg [31:0] x_temp, y_temp;  
    reg state;  // 0: idle, 1: compute

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x3 <= 0;  
            y3 <= 0;  
            done <= 0;  
            state <= 0;  
        end else begin  
            case(state)  
                0: begin  
                    if (x1 == x2 && y1 == y2) begin  
                        // Doubling case (x1, y1) + (x1, y1)  
                        m <= (3 * x1 * x1) / (2 * y1);  
                        state <= 1;  
                    end else begin  
                        // Addition case (x1, y1) + (x2, y2)  
                        x_diff <= x2 - x1;  
                        y_diff <= y2 - y1;  
                        m <= y_diff / x_diff;  
                        state <= 1;  
                    end  
                end  
                1: begin  
                    // Calculate new point (x3, y3)  
                    x_temp <= (m * m) - x1 - x2;  
                    y_temp <= (m * (x1 - x_temp)) - y1;  
                    x3 <= x_temp % p;  
                    y3 <= y_temp % p;  
                    done <= 1;  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule