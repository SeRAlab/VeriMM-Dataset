module ones_complement (
    input [3:0] in,
    output reg [3:0] out
);

    always @ (in) begin
        out = ~in;
    end

endmodule