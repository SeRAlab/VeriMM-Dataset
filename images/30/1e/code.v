module RLE(
    input [7:0] pixel_in,
    input pixel_valid,
    output reg [7:0] pixel_out,
    output reg [7:0] count_out,
    output reg output_valid
);
    reg [7:0] current_pixel;
    reg [7:0] count;

    always @(posedge pixel_valid) begin
        if (pixel_in == current_pixel) begin
            count <= count + 1;
        end else begin
            if (current_pixel !== 8'bx) begin
                pixel_out <= current_pixel;
                count_out <= count;
                output_valid <= 1;
            end
            current_pixel <= pixel_in;
            count <= 1;
        end
    end

    always @(negedge pixel_valid) begin
        output_valid <= 0;
    end

    initial begin
        current_pixel = 8'bx;
        count = 0;
        output_valid = 0;
    end
endmodule