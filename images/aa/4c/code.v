module top_module(
    input [3:0] in,
    output reg [3:0] out
);always @(*) begin
        case (in)
            4'b0000: out = 4'b0001;
            4'b0001: out = 4'b0010;
            4'b0010: out = 4'b0100;
            4'b0011: out = 4'b1000;
            default: out = 4'b0000;
        endcase
    end
endmodule