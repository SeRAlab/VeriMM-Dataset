module top_module(
    input [3:0] in,
    input [1:0] control,
    output reg [3:0] out
);always @(*) begin
    case (control)
        2'b00: out = in << 1;
        2'b01: out = in << 2;
        2'b10: out = in >> 1;
        2'b11: out = in >> 2;
    endcase
end

endmodule