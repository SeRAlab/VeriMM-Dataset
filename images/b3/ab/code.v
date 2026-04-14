module top_module(
    input input1,
    input input2,
    input [3:0] input3,
    input [3:0] input4,
    input [7:0] input5,
    input [7:0] input6,
    input [7:0] input7,
    input [7:0] input8,
    input [7:0] input9,
    input [7:0] input10,
    output reg [15:0] output1
);reg [3:0] sum1;
    reg [47:0] concat1;

    always @(*) begin
        if (input2 == 0) begin
            output1 = 0;
        end else begin
            output1 = input1;
        end

        sum1 = input3 + input4;
        concat1 = {input5, input6, input7, input8, input9, input10};
        output1 = output1 + {sum1, concat1};
    end

endmodule