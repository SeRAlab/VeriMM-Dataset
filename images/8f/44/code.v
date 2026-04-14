module top_module(
    input in0,
    input in1,
    input in2,
    input in3,
    input en,
    output reg out  // Changed output to reg type
);always @(*) begin
        if (en == 1'b1) begin
            casez({in3, in2, in1, in0})
                4'b0000: out = in0;
                4'b0001: out = in1;
                4'b0010: out = in2;
                4'b0011: out = in3;
                default: out = 1'b0;
            endcase
        end else begin
            out = 1'b0;
        end
    end

endmodule