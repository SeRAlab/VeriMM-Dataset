module decoder_3_to_8 (
    input [2:0] in,
    input enable,
    output reg [7:0] out
);
    reg [7:0] last_out;

    always @(*) begin
        if (enable) begin
            out = 8'b00000000; // Reset output
            case (in)
                3'b000: out[0] = 1;
                3'b001: out[1] = 1;
                3'b010: out[2] = 1;
                3'b011: out[3] = 1;
                3'b100: out[4] = 1;
                3'b101: out[5] = 1;
                3'b110: out[6] = 1;
                3'b111: out[7] = 1;
                default: out = 8'b00000000;
            endcase
            last_out = out; // Store current output
        end else begin
            out = last_out; // Forward last output if enable is low
        end
    end
endmodule