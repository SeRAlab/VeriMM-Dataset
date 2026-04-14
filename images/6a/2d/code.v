module top_module(
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input [7:0] in5,
    input [7:0] in6,
    input [7:0] in7,
    output reg [7:0] out0,
    output reg [7:0] out1,
    output reg [7:0] out2,
    output reg [7:0] out3,
    output reg [7:0] out4,
    output reg [7:0] out5,
    output reg [7:0] out6,
    output reg [7:0] out7
);reg [7:0] data[0:7];
integer i, j;
reg [2:0] k;

initial begin
    data[0] = in0;
    data[1] = in1;
    data[2] = in2;
    data[3] = in3;
    data[4] = in4;
    data[5] = in5;
    data[6] = in6;
    data[7] = in7;

    for (k = 0; k < 3; k = k + 1) begin
        for (i = 0; i < 8; i = i + 1) begin
            for (j = i + 1; j < 8; j = j + 1) begin
                if (data[i] > data[j]) begin
                    data[i] = data[i] + data[j];
                    data[j] = data[i] - data[j];
                    data[i] = data[i] - data[j];
                end
            end
        end
    end

    out0 = data[0];
    out1 = data[1];
    out2 = data[2];
    out3 = data[3];
    out4 = data[4];
    out5 = data[5];
    out6 = data[6];
    out7 = data[7];
end

endmodule