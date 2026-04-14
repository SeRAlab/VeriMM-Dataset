module qr_decomposition (  
    input clk,  
    input reset,  
    input start,  
    input [31:0] a11,  
    input [31:0] a12,  
    input [31:0] a21,  
    input [31:0] a22,  
    output reg [31:0] q11,  
    output reg [31:0] q12,  
    output reg [31:0] q21,  
    output reg [31:0] q22,  
    output reg [31:0] r11,  
    output reg [31:0] r12,  
    output reg [31:0] r21,  
    output reg [31:0] r22,  
    output reg done  
);  

    reg [31:0] norm_a1;  
    reg [31:0] r11_temp, r12_temp, r21_temp, r22_temp;  
    reg [1:0] state;  

    parameter IDLE = 2'b00, CALC_QR = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q11 <= 0;  
            q12 <= 0;  
            q21 <= 0;  
            q22 <= 0;  
            r11 <= 0;  
            r12 <= 0;  
            r21 <= 0;  
            r22 <= 0;  
            done <= 0;  
            state <= IDLE;  
        end  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        // Compute R11 and Q1  
                        r11_temp = a11;  
                        norm_a1 = r11_temp * r11_temp;  
                        r12_temp = a12;  
                        q11 = r11_temp;  
                        q12 = r12_temp - (r11_temp * r12_temp) / norm_a1;  
                        state <= CALC_QR;  
                    end  
                end  
                CALC_QR: begin  
                    // Compute R21 and Q2  
                    r21_temp = a21;  
                    r22_temp = a22;  
                    r21 = r21_temp;  
                    r22 = r22_temp;  
                    q21 = r21_temp - (q11 * r21_temp) / norm_a1;  
                    q22 = r22_temp - (q12 * r21_temp) / norm_a1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1;  
                    // Set R matrix  
                    r11 <= norm_a1;  
                    r12 <= q12;  
                    r21 <= 0;  
                    r22 <= 0;  
                end  
            endcase  
        end  
    end  
endmodule