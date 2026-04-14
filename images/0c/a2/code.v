module DWT_Haar (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    output reg [7:0] approx_out,  
    output reg [7:0] detail_out,  
    output reg done  
);  
    reg [3:0] state;  
    reg [7:0] temp_approx;  
    reg [7:0] temp_detail;  
    parameter IDLE = 4'b0000,  
              CALC = 4'b0001,  
              DONE = 4'b0010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            approx_out <= 8'd0;  
            detail_out <= 8'd0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    temp_approx <= (data_in[7:0] + data_in[6:0]) >> 1;  
                    temp_detail <= (data_in[7:0] - data_in[6:0]) >> 1;  
                    state <= CALC;  
                end  
                CALC: begin  
                    approx_out <= temp_approx;  
                    detail_out <= temp_detail;  
                    done <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule