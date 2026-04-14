module mux_2_to_1 (
    input [3:0] in0,
    input [3:0] in1,
    input sel,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 4'b0000; // Default case for safety
    endcase
end

endmodule