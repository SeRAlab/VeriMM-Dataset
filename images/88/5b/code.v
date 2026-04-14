module top_module(
    input [8:0] doutb,
    output reg [2:0] mux_out
);always @(*) begin
    case(doutb[2:0])
        3'b000: mux_out = doutb[8:6];
        3'b001: mux_out = doutb[5:3];
        3'b010: mux_out = doutb[2:0];
        default: mux_out = 3'b0;
    endcase
end

endmodule