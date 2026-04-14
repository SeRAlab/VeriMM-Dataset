module multi_input_output(
    input in1,
    input [1:0] in2,
    input [2:0] in3,
    input [3:0] in4,
    input [4:0] in5,
    input [5:0] in6,
    input [6:0] in7,
    input [7:0] in8,
    input [8:0] in9,
    output reg [9:0] out
);

    always @(*) begin
        if (in1 == 1'b0) begin
            out = {1'b0, in2 + in3};
        end
        else begin
            out = {1'b0, (in4 | in5) << 1};
        end
        
        if (in6 >= in7) begin
            out = out ^ {1'b0, in8, in9};
        end
        else begin
            out = {1'b0, (in8 & in9) >> 1};
        end
    end

endmodule