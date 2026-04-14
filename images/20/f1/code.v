module mux4to1 (
    input [1:0] sel,          // 2-bit select signal
    input [31:0] in0,        // 32-bit input 0
    input [31:0] in1,        // 32-bit input 1
    input [31:0] in2,        // 32-bit input 2
    input [31:0] in3,        // 32-bit input 3
    output reg [31:0] out    // 32-bit output
);

always @(*) begin
    case(sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 32'b0;  // Default case
    endcase
end

endmodule