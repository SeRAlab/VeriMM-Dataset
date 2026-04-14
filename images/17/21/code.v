module otsu_threshold (
    input [7:0] pixel_in,
    output reg [7:0] pixel_out
);
    // Predefined threshold for simplicity
    parameter THRESHOLD = 128;

    always @(*) begin
        if (pixel_in >= THRESHOLD) 
            pixel_out = 8'b11111111; // 255
        else 
            pixel_out = 8'b00000000; // 0
    end
endmodule