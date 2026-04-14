module mux_2_to_1 (
    input [31:0] data0,
    input [31:0] data1,
    input sel,
    output reg [31:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = data0;
        1'b1: out = data1;
        default: out = 32'b0; // Default case (not really necessary)
    endcase
end

endmodule