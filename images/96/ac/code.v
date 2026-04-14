module mux4to1 (
    input wire [1:0] sel,
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 1'b0;
        endcase
    end

endmodule