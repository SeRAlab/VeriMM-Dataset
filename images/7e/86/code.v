module top_module(
    input [7:0] in,
    output reg [2:0] pos );wire [7:0] in_not;
    wire [7:0] in_and;
    wire [3:0] in_add;
    wire [2:0] in_add_not;

    assign in_not = ~in;
    assign in_and = in & in_not;
    assign in_add = {in_and[0], in_and[1], in_and[2], in_and[3], in_and[4], in_and[5], in_and[6], in_and[7]};
    assign in_add_not = ~in_add;

    always @* begin
        if (in_add[0]) pos = 0;
        else if (in_add[1]) pos = 1;
        else if (in_add[2]) pos = 2;
        else if (in_add[3]) pos = 3;
        else if (in_add[4]) pos = 4;
        else if (in_add[5]) pos = 5;
        else if (in_add[6]) pos = 6;
        else if (in_add[7]) pos = 7;
        else pos = 8;
    end

endmodule