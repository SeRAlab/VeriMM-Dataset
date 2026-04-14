module adder(
    input [31:0] in1,
    input [31:0] in2,
    input enable,
    output reg [31:0] out
);

    always @(*) begin
        if(enable) begin
            out = in1 + in2;
        end
    end

endmodule