module top_module(
    input [3:0] input_shrink,
    output reg [15:0] output_bitmap
);// Remove unused wires and signals
    // wire [3:0] SHRINK = input_shrink;
    // wire CK = 1'b0;
    // wire L = 1'b0;
    // wire OUTA, OUTB;

    always @(input_shrink) begin
        case (input_shrink)
            4'h0: output_bitmap <= 16'b0000000010000000;
            4'h1: output_bitmap <= 16'b0000100010000000;
            4'h2: output_bitmap <= 16'b0000100010001000;
            4'h3: output_bitmap <= 16'b0010100010001000;
            4'h4: output_bitmap <= 16'b0010100010001010;
            4'h5: output_bitmap <= 16'b0010101010001010;
            4'h6: output_bitmap <= 16'b0010101010101010;
            4'h7: output_bitmap <= 16'b1010101010101010;
            4'h8: output_bitmap <= 16'b1010101011101010;
            4'h9: output_bitmap <= 16'b1011101011101010;
            4'hA: output_bitmap <= 16'b1011101011101011;
            4'hB: output_bitmap <= 16'b1011101111101011;
            4'hC: output_bitmap <= 16'b1011101111101111;
            4'hD: output_bitmap <= 16'b1111101111101111;
            4'hE: output_bitmap <= 16'b1111101111111111;
            4'hF: output_bitmap <= 16'b1111111111111111;
            default: output_bitmap <= 16'b0; // Reset output on invalid input
        endcase
    end

endmodule