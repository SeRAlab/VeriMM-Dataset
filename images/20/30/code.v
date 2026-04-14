module png_compressor (
    input [7:0] pixel_in,
    input pixel_valid,
    output reg [7:0] pixel_out,
    output reg [7:0] count_out,
    output reg valid_output
);

reg [7:0] last_pixel;
reg [3:0] count;

always @(posedge pixel_valid) begin
    if (pixel_in == last_pixel) begin
        count <= count + 1;
    end else begin
        pixel_out <= last_pixel;
        count_out <= count;
        valid_output <= 1;
        last_pixel <= pixel_in;
        count <= 1;
    end
end

always @(negedge pixel_valid) begin
    pixel_out <= last_pixel;
    count_out <= count;
    valid_output <= (count > 0);
end

initial begin
    last_pixel = 0;
    count = 1;
    valid_output = 0;
end

endmodule