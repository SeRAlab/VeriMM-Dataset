module top_module(
    input [3:0] num1,
    input [3:0] num2,
    output reg [3:0] larger_num
);reg [3:0] pipeline_reg1;
reg [3:0] pipeline_reg2;

// Pipeline stage 1
always @(num1) begin
    pipeline_reg1 <= num1;
end

// Pipeline stage 2
always @(num2) begin
    pipeline_reg2 <= num2;
end

// Comparator module
always @(*) begin
    if (pipeline_reg1 > pipeline_reg2) begin
        larger_num <= pipeline_reg1;
    end else begin
        larger_num <= pipeline_reg2;
    end
end

endmodule