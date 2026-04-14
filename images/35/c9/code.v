module decoder3to8 (
    input [2:0] in,
    input enable,
    output reg [7:0] out
);
    always @(*) begin
        if (enable) begin
            out = 8'b00000000; // Default to all low
            out[in] = 1'b1;    // Set the output corresponding to the input
        end else begin
            out = 8'b00000000; // All outputs low when enable is low
        end
    end
endmodule