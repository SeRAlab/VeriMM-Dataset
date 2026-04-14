module top_module(
    input signed [31:0] din,
    input [5:0] in_size,
    output reg signed [31:0] dout
);always @(*) begin
    case(in_size)
        2: dout = {{30{din[0]}}, din};
        4: dout = {{28{din[0]}}, din};
        8: dout = {{24{din[0]}}, din};
        16: dout = {{16{din[0]}}, din};
        32: dout = din;
        default: dout = 0;
    endcase
end

endmodule