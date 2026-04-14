module fft_4point (  
    input clk,  
    input reset,  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [15:0] y0_real,  
    output reg [15:0] y0_imag,  
    output reg [15:0] y1_real,  
    output reg [15:0] y1_imag,  
    output reg [15:0] y2_real,  
    output reg [15:0] y2_imag,  
    output reg [15:0] y3_real,  
    output reg [15:0] y3_imag  
);  

    reg [15:0] temp_real[0:3];  
    reg [15:0] temp_imag[0:3];  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y0_real <= 0;  
            y0_imag <= 0;  
            y1_real <= 0;  
            y1_imag <= 0;  
            y2_real <= 0;  
            y2_imag <= 0;  
            y3_real <= 0;  
            y3_imag <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    temp_real[0] <= x0 + x1;  
                    temp_real[1] <= x2 + x3;  
                    temp_real[2] <= x0 - x1;  
                    temp_real[3] <= x2 - x3;  
                    temp_imag[0] <= 0;  
                    temp_imag[1] <= 0;  
                    temp_imag[2] <= 0;  
                    temp_imag[3] <= 0;  
                    state <= 1;  
                end  
                1: begin  
                    y0_real <= temp_real[0];  
                    y0_imag <= temp_imag[0];  
                    y1_real <= temp_real[1];  
                    y1_imag <= temp_imag[1];  
                    y2_real <= temp_real[2];  
                    y2_imag <= temp_imag[2];  
                    y3_real <= temp_real[3];  
                    y3_imag <= temp_imag[3];  
                    state <= 2;  
                end  
            endcase  
        end  
    end  
endmodule