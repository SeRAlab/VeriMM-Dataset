module fft_4point (  
    input clk,  
    input reset,  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [15:0] y0,  
    output reg [15:0] y1,  
    output reg [15:0] y2,  
    output reg [15:0] y3  
);  
    reg [15:0] temp0, temp1, temp2, temp3;  
    reg [3:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y0 <= 0;  
            y1 <= 0;  
            y2 <= 0;  
            y3 <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    temp0 <= x0 + x1;  
                    temp1 <= x0 - x1;  
                    temp2 <= x2 + x3;  
                    temp3 <= x2 - x3;  
                    state <= 1;  
                end  
                1: begin  
                    y0 <= temp0 + temp2;  
                    y1 <= temp1 + (temp3 << 1);  
                    y2 <= temp0 - temp2;  
                    y3 <= temp1 - (temp3 << 1);  
                    state <= 2;  
                end  
                2: begin  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule