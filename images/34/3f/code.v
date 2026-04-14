module png_compressor (
    input [31:0] pixel_data, // 4 pixels, 8 bits each
    output reg [255:0] rle_data, // RLE encoded output, arbitrary length for this example
    output reg [7:0] rle_length // output length of RLE data
);
    integer i;
    reg [7:0] count;
    reg [7:0] current_pixel;
    
    always @(*) begin
        rle_length = 0;
        rle_data = 0;
        count = 1;
        current_pixel = pixel_data[7:0]; // Start with the first pixel
        
        for (i = 1; i < 4; i = i + 1) begin
            if (pixel_data[i*8 +: 8] == current_pixel) begin
                count = count + 1; // Increase count if same pixel
            end else begin
                // Store the current run-length
                rle_data[rle_length*16 +: 16] = {count, current_pixel};
                rle_length = rle_length + 1;
                current_pixel = pixel_data[i*8 +: 8]; // Update to new pixel
                count = 1; // Reset count for new pixel
            end
        end
        // Store the last run-length
        rle_data[rle_length*16 +: 16] = {count, current_pixel};
        rle_length = rle_length + 1;
    end
endmodule