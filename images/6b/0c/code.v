module top_module(
    input [15:0] A,
    input [3:0] B,
    input [3:0] select,
    output reg [15:0] shift_left,
    output reg [15:0] shift_right,
    output reg [15:0] out
);reg [15:0] shifted_value;
    reg [3:0] decoder_enable;
    reg [15:0] decoder_output;

    always @(*) begin
        case (select)
            4'b0000: begin // Barrel Shifter
                if (B[3] == 1) begin
                    shifted_value = {A[14:0], 1'b0};
                end else begin
                    shifted_value = {1'b0, A[15:1]};
                end
                shift_left = shifted_value;
                shift_right = shifted_value;
            end
            4'b0001: begin // 4-to-16 Decoder
                decoder_enable = ~B;
                decoder_output = 16'b0;
                if (decoder_enable[0] == 1) begin
                    decoder_output[0] = 1'b1;
                end
                if (decoder_enable[1] == 1) begin
                    decoder_output[1] = 1'b1;
                end
                if (decoder_enable[2] == 1) begin
                    decoder_output[2] = 1'b1;
                end
                if (decoder_enable[3] == 1) begin
                    decoder_output[3] = 1'b1;
                end
                out = decoder_output;
            end
            default: begin
                // Do nothing
            end
        endcase
    end

endmodule