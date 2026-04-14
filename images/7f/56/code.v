module top_module(
    input clk,
    input reset,
    input [31:0] data_in1,
    input [31:0] data_in2,
    output [31:0] sum_out
);// Byte-order reversing module
    wire [31:0] reversed_data_in1;
    wire [31:0] reversed_data_in2;

    assign reversed_data_in1 = {data_in1[7:0], data_in1[15:8], data_in1[23:16], data_in1[31:24]};
    assign reversed_data_in2 = {data_in2[7:0], data_in2[15:8], data_in2[23:16], data_in2[31:24]};

    // Full adder module
    reg [31:0] carry;
    reg [31:0] sum;

    always @(posedge clk) begin
        if (reset) begin
            carry <= 0;
            sum <= 0;
        end else begin
            {carry, sum} <= reversed_data_in1 + reversed_data_in2 + carry;
        end
    end

    // Byte-order reversing module for output
    assign sum_out = {sum[7:0], sum[15:8], sum[23:16], sum[31:24]};

endmodule