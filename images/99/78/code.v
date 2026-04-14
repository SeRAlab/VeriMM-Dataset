module ShiftRegister (
    input [15:0] data,
    input [1:0] control,
    output reg [15:0] out
);
    always @(*) begin
        case (control)
            2'b00: out = data;
            2'b01: out = data << 1;
            2'b10: out = data >> 1;
            2'b11: out = data;
            default: out = 16'b0;
        endcase
    end
endmodule