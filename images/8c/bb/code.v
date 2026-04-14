module top_module(
    input [7:0] input1,
    input [7:0] input2,
    input carry_in,
    output [7:0] sum,
    output carry_out,
    output overflow_flag
);reg [7:0] stage1_out;
reg [7:0] stage2_out;
reg [7:0] stage3_out;
reg [7:0] stage4_out;
reg [7:0] stage5_out;
reg [7:0] stage6_out;
reg [7:0] stage7_out;
reg [7:0] stage8_out;

reg carry1;
reg carry2;
reg carry3;
reg carry4;
reg carry5;
reg carry6;
reg carry7;

assign sum = stage8_out;
assign carry_out = carry7;
assign overflow_flag = (stage8_out > 8'hFF);

// Stage 1
always @(*) begin
    stage1_out = input1 + input2 + carry_in;
    carry1 = (stage1_out > 8'hFF);
end

// Stage 2
always @(*) begin
    stage2_out = input1 + input2 + carry1;
    carry2 = (stage2_out > 8'hFF);
end

// Stage 3
always @(*) begin
    stage3_out = input1 + input2 + carry2;
    carry3 = (stage3_out > 8'hFF);
end

// Stage 4
always @(*) begin
    stage4_out = input1 + input2 + carry3;
    carry4 = (stage4_out > 8'hFF);
end

// Stage 5
always @(*) begin
    stage5_out = input1 + input2 + carry4;
    carry5 = (stage5_out > 8'hFF);
end

// Stage 6
always @(*) begin
    stage6_out = input1 + input2 + carry5;
    carry6 = (stage6_out > 8'hFF);
end

// Stage 7
always @(*) begin
    stage7_out = input1 + input2 + carry6;
    carry7 = (stage7_out > 8'hFF);
end

// Stage 8
always @(*) begin
    stage8_out = input1 + input2 + carry7;
end

endmodule