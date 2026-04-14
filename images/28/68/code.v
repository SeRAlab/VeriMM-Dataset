module nearest_neighbor_interpolation(
    input [7:0] pixel1,
    input [7:0] pixel2,
    input select, // 0 for pixel1, 1 for pixel2
    output reg [7:0] output_pixel
);

always @(*) begin
    if (select) 
        output_pixel = pixel2;
    else 
        output_pixel = pixel1;
end

endmodule