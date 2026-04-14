module multi_div_add_sub(
    input clk,
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    output [3:0] out0,
    output [3:0] out1
);

    reg [3:0] reg_out0;
    reg [3:0] reg_out1;

    always @(posedge clk) begin
        reg_out0 <= (in0 * 2) + in2;
        reg_out1 <= (in1 / 4) - in2;
    end

    assign out0 = reg_out0;
    assign out1 = reg_out1;

endmodule