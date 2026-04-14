module jpeg_dct(input clk,  
                 input reset,  
                 input [7:0] pixel_00,  
                 input [7:0] pixel_01,  
                 input [7:0] pixel_10,  
                 input [7:0] pixel_11,  
                 output reg [15:0] dct_00,  
                 output reg [15:0] dct_01,  
                 output reg [15:0] dct_10,  
                 output reg [15:0] dct_11,  
                 output reg done);  

    reg [15:0] sum_x, sum_y;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, CALC = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            dct_00 <= 0;  
            dct_01 <= 0;  
            dct_10 <= 0;  
            dct_11 <= 0;  
            done <= 0;  
            state <= IDLE;  
        end  
        else begin  
            case (state)  
                IDLE: begin  
                    if (pixel_00 !== 8'bx) begin  
                        sum_x <= pixel_00 + pixel_01 + pixel_10 + pixel_11;  
                        sum_y <= pixel_00 + pixel_01 - pixel_10 - pixel_11;  
                        state <= CALC;  
                    end  
                end  
                CALC: begin  
                    dct_00 <= (sum_x + sum_y) >> 2;  
                    dct_01 <= (sum_x - sum_y) >> 2;  
                    dct_10 <= (sum_x + sum_y) >> 2;  
                    dct_11 <= (sum_x - sum_y) >> 2;  
                    done <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    // Wait for reset or new input  
                    if (pixel_00 === 8'bx) begin  
                        done <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule