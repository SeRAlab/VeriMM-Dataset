module top_module(
    input [3:0] B,
    output reg O0,
    output reg O1,
    output reg O2,
    output reg O3
);always @(*) begin
    case(B)
        4'b0001: begin O0 = 1; O1 = 0; O2 = 0; O3 = 0; end
        4'b0010: begin O0 = 0; O1 = 1; O2 = 0; O3 = 0; end
        4'b0100: begin O0 = 0; O1 = 0; O2 = 1; O3 = 0; end
        4'b1000: begin O0 = 0; O1 = 0; O2 = 0; O3 = 1; end
        default: begin O0 = 0; O1 = 0; O2 = 0; O3 = 0; end
    endcase
end

endmodule