module png_compression (
    input [2:0] color_in,
    output reg [2:0] compressed_out
);
    always @(*) begin
        if (color_in < 4)
            compressed_out = 3'b000; // Output 0 for values 0 to 3
        else
            compressed_out = 3'b001; // Output 1 for values 4 to 7
    end
endmodule