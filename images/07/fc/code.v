module mux_2to1 (
    input [3:0] data0,
    input [3:0] data1,
    input sel,
    output reg [3:0] mux_out
);

always @(*) begin
    case (sel)
        1'b0: mux_out = data0;
        1'b1: mux_out = data1;
        default: mux_out = 4'b0000; // default case for safety
    endcase
end

endmodule