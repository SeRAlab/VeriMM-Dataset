module decoder_3to8 (
    input wire [2:0] A,   // 3-bit input
    input wire EN,        // Enable input
    output reg [7:0] Y    // 8 outputs
);
    always @(*) begin
        if (EN) begin
            Y = 8'b00000000; // Reset outputs
            Y[A] = 1'b1;     // Activate the corresponding output
        end else begin
            Y = 8'b11111111; // Set all outputs high when not enabled
        end
    end
endmodule