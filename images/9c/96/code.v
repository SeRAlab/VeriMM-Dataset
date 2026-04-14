module top_module(
    input clk,
    input d,
    input [255:0] in,
    input [7:0] sel,
    output reg [7:0] out  // Change 'output' to 'output reg'
);reg [2:0] shift_reg;
    wire [15:0] decoder_out;

    // Shift register implementation using D flip-flop and multiplexer
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], d};
    end

    assign decoder_out = (sel == 8'h00) ? in[255:240] :
                         (sel == 8'h01) ? in[239:224] :
                         (sel == 8'h02) ? in[223:208] :
                         (sel == 8'h03) ? in[207:192] :
                         (sel == 8'h04) ? in[191:176] :
                         (sel == 8'h05) ? in[175:160] :
                         (sel == 8'h06) ? in[159:144] :
                         (sel == 8'h07) ? in[143:128] :
                         (sel == 8'h08) ? in[127:112] :
                         (sel == 8'h09) ? in[111:96] :
                         (sel == 8'h0A) ? in[95:80] :
                         (sel == 8'h0B) ? in[79:64] :
                         (sel == 8'h0C) ? in[63:48] :
                         (sel == 8'h0D) ? in[47:32] :
                         (sel == 8'h0E) ? in[31:16] :
                                          in[15:0];

    // Functional module to select bits from shift register based on decoder output
    always @(*) begin
        case(decoder_out)
            16'h0001: out = {shift_reg[2], shift_reg[1], shift_reg[0], 5'b0};
            16'h0002: out = {shift_reg[2], shift_reg[1], 5'b0, shift_reg[0]};
            16'h0004: out = {shift_reg[2], 5'b0, shift_reg[1], shift_reg[0]};
            16'h0008: out = {5'b0, shift_reg[2], shift_reg[1], shift_reg[0]};
            16'h0010: out = {shift_reg[1], shift_reg[0], shift_reg[2], 5'b0};
            16'h0020: out = {shift_reg[1], shift_reg[0], 5'b0, shift_reg[2]};
            16'h0040: out = {shift_reg[1], 5'b0, shift_reg[0], shift_reg[2]};
            16'h0080: out = {5'b0, shift_reg[1], shift_reg[0], shift_reg[2]};
            default: out = 8'b0;
        endcase
    end

endmodule