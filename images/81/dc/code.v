module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input PRI,
    input [1:0] SEL,
    output reg [3:0] out
);always @(*) begin
    if (PRI) begin
        if (in3 != 0) begin
            out = in3;
        end else if (in2 != 0) begin
            out = in2;
        end else if (in1 != 0) begin
            out = in1;
        end else begin
            out = in0;
        end
    end else begin
        case (SEL)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end
end

endmodule