module fft_4point (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] real_in0,  
    input wire [7:0] imag_in0,  
    input wire [7:0] real_in1,  
    input wire [7:0] imag_in1,  
    input wire [7:0] real_in2,  
    input wire [7:0] imag_in2,  
    input wire [7:0] real_in3,  
    input wire [7:0] imag_in3,  
    output reg [7:0] real_out0,  
    output reg [7:0] imag_out0,  
    output reg [7:0] real_out1,  
    output reg [7:0] imag_out1,  
    output reg [7:0] real_out2,  
    output reg [7:0] imag_out2,  
    output reg [7:0] real_out3,  
    output reg [7:0] imag_out3  
);  
    reg [7:0] r[0:3];  
    reg [7:0] i[0:3];  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
        end else begin  
            case (state)  
                2'b00: begin  
                    r[0] <= real_in0;  
                    i[0] <= imag_in0;  
                    r[1] <= real_in1;  
                    i[1] <= imag_in1;  
                    r[2] <= real_in2;  
                    i[2] <= imag_in2;  
                    r[3] <= real_in3;  
                    i[3] <= imag_in3;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    // FFT computation for 4-point FFT  
                    // Example of FFT butterflies  
                    real_out0 <= r[0] + r[1];  
                    imag_out0 <= i[0] + i[1];  
                    real_out1 <= r[0] - r[1];  
                    imag_out1 <= i[0] - i[1];  
                    real_out2 <= r[2] + r[3];  
                    imag_out2 <= i[2] + i[3];  
                    real_out3 <= r[2] - r[3];  
                    imag_out3 <= i[2] - i[3];  
                    state <= 2'b10;  
                end  
                2'b10: begin  
                    // Final state, might want to add some delay or processing  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule