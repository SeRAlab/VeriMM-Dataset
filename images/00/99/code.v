module gaussian_blur (
    input [7:0] P1, P2, P3,
    input [7:0] P4, P5, P6,
    input [7:0] P7, P8, P9,
    output reg [7:0] output_pixel
);
    
    always @(*) begin
        output_pixel = (P1 + 2*P2 + P3 + 2*P4 + 4*P5 + 2*P6 + P7 + 2*P8 + P9) / 16;
    end
endmodule