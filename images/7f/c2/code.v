module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    input in6,
    input in7,
    input in8,
    input in9,
    input in10,
    output reg out1
);always @(*) begin
        if (in1) out1 = 1;
        else if (in2) out1 = 0;
        else if (in3) out1 = ~out1;
        else if (in4) out1 = in5 & in6;
        else if (in7) out1 = in8 | in9;
        else if (in10) out1 = in8 ^ in9;
    end

endmodule