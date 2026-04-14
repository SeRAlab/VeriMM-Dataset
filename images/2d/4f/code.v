module fft_4point(  
    input clk,  
    input reset,  
    input [7:0] x0_real,  
    input [7:0] x0_imag,  
    input [7:0] x1_real,  
    input [7:0] x1_imag,  
    input [7:0] x2_real,  
    input [7:0] x2_imag,  
    input [7:0] x3_real,  
    input [7:0] x3_imag,  
    output reg [7:0] y0_real,  
    output reg [7:0] y0_imag,  
    output reg [7:0] y1_real,  
    output reg [7:0] y1_imag,  
    output reg [7:0] y2_real,  
    output reg [7:0] y2_imag,  
    output reg [7:0] y3_real,  
    output reg [7:0] y3_imag,  
    output reg valid  
);  
    reg [2:0] state;  
    reg [7:0] temp_real[0:3];  
    reg [7:0] temp_imag[0:3];  
    parameter IDLE = 3'd0, LOAD = 3'd1, COMPUTE = 3'd2, DONE = 3'd3;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            valid <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    state <= LOAD;  
                end  
                LOAD: begin  
                    temp_real[0] <= x0_real;  
                    temp_imag[0] <= x0_imag;  
                    temp_real[1] <= x1_real;  
                    temp_imag[1] <= x1_imag;  
                    temp_real[2] <= x2_real;  
                    temp_imag[2] <= x2_imag;  
                    temp_real[3] <= x3_real;  
                    temp_imag[3] <= x3_imag;  
                    state <= COMPUTE;  
                end  
                COMPUTE: begin  
                    // FFT computation for 4 points  
                    y0_real <= temp_real[0] + temp_real[1] + temp_real[2] + temp_real[3];  
                    y0_imag <= temp_imag[0] + temp_imag[1] + temp_imag[2] + temp_imag[3];  
                    y1_real <= temp_real[0] - temp_real[2] + (temp_imag[1] - temp_imag[3]);  
                    y1_imag <= temp_imag[0] - temp_imag[2] - (temp_real[1] - temp_real[3]);  
                    y2_real <= temp_real[0] - temp_real[1] + temp_real[2] - temp_real[3];  
                    y2_imag <= temp_imag[0] - temp_imag[1] + temp_imag[2] - temp_imag[3];  
                    y3_real <= temp_real[0] - temp_real[1] - temp_real[2] + temp_real[3];  
                    y3_imag <= temp_imag[0] - temp_imag[1] - temp_imag[2] + temp_imag[3];  
                    valid <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    valid <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule