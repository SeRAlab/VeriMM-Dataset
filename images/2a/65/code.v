module morphological_dilation (
    input [4:0] in0, 
    input [4:0] in1, 
    input [4:0] in2, 
    input [4:0] in3, 
    input [4:0] in4, 
    output reg [4:0] out0, 
    output reg [4:0] out1, 
    output reg [4:0] out2, 
    output reg [4:0] out3, 
    output reg [4:0] out4
);
    integer i, j;

    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                if (i > 0 && j > 0 && i < 4 && j < 4) begin
                    out0[i] = in0[i-1] | in0[i] | in0[i+1];
                    out1[i] = in1[i-1] | in1[i] | in1[i+1];
                    out2[i] = in2[i-1] | in2[i] | in2[i+1];
                    out3[i] = in3[i-1] | in3[i] | in3[i+1];
                    out4[i] = in4[i-1] | in4[i] | in4[i+1];
                end
            end
        end
    end
endmodule