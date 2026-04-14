module top_module(
    input [3:0] in,
    output reg [1:0] out
);always @(*) begin
        case (in)
            4'b0000: out = 2'b00;
            4'b0001: out = 2'b01;
            4'b0010: out = 2'b10;
            default: out = 2'b00;
        endcase
    end

endmodule