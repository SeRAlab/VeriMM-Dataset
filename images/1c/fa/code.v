module encoder_4to2 (
    input [3:0] in,
    output reg [1:0] out
);
    always @(*) begin
        case (in)
            4'b0001: out = 2'b00;  // input 0 is high
            4'b0010: out = 2'b01;  // input 1 is high
            4'b0100: out = 2'b10;  // input 2 is high
            4'b1000: out = 2'b11;  // input 3 is high
            default: out = 2'b00;   // none are high
        endcase
    end
endmodule