module FFT_4point (
    input clk,
    input reset,
    input [15:0] re_in0, im_in0,
    input [15:0] re_in1, im_in1,
    input [15:0] re_in2, im_in2,
    input [15:0] re_in3, im_in3,
    output reg [15:0] re_out0, im_out0,
    output reg [15:0] re_out1, im_out1,
    output reg [15:0] re_out2, im_out2,
    output reg [15:0] re_out3, im_out3
);
    reg [15:0] re[0:3], im[0:3];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            re_out0 <= 0; im_out0 <= 0;
            re_out1 <= 0; im_out1 <= 0;
            re_out2 <= 0; im_out2 <= 0;
            re_out3 <= 0; im_out3 <= 0;
        end else begin
            // Load inputs into registers
            re[0] <= re_in0; im[0] <= im_in0;
            re[1] <= re_in1; im[1] <= im_in1;
            re[2] <= re_in2; im[2] <= im_in2;
            re[3] <= re_in3; im[3] <= im_in3;
            
            // Perform FFT calculations (simplified for 4-point FFT)
            re_out0 <= re[0] + re[1] + re[2] + re[3];
            im_out0 <= im[0] + im[1] + im[2] + im[3];

            re_out1 <= re[0] - re[1] + (im[2] - im[3]);
            im_out1 <= im[0] - im[1] + (re[2] - re[3]);

            re_out2 <= re[0] - re[1] - re[2] + re[3];
            im_out2 <= im[0] - im[1] - im[2] + im[3];

            re_out3 <= re[0] - re[1] - (im[2] - im[3]);
            im_out3 <= im[0] - im[1] - (re[2] - re[3]);
        end
    end
endmodule