module mux2to1(
    input [15:0] data0,
    input [15:0] data1,
    input sel,
    output reg [15:0] out
);

always @(*) begin
    case(sel)
        1'b0: out = data0;
        1'b1: out = data1;
        default: out = 16'b0; // default case
    endcase
end

endmodule