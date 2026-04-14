module top_module(
    input [3:0] input1,
    input [1:0] input2,
    input input3,
    input input4,
    input input5,
    input input6,
    input input7,
    input input8,
    output reg output1
);always @(*) begin
        if (input1 >= 4'b0110 && input2 == 2'b10) begin
            output1 = 1;
        end else if (input3 == 1 && input4 == 0) begin
            output1 = 0;
        end else if (input5 == 1 && input6 == 1 && input7 == 1 && input8 == 1) begin
            output1 = 1;
        end else begin
            output1 = 0;
        end
    end

endmodule