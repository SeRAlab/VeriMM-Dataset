module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input ctrl,
    output reg [3:0] out
);always @(*) begin
    // Concatenate the four input bits
    out = {in1, in2, in3, in4};

    // Invert the bits corresponding to in1 and in2 if ctrl is 1
    if (ctrl == 1) begin
        out[3:2] = ~out[3:2];
    end
end

endmodule