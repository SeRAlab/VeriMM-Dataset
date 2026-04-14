module nearest_neighbor_interpolation (
    input wire [7:0] pixel_value, // Input pixel value
    input wire control,            // Control signal
    output reg [7:0] output_value  // Output value
);
    always @(*) begin
        if (control) begin
            output_value = pixel_value; // Output the nearest neighbor pixel value
        end else begin
            output_value = 8'b00000000;  // Output default value
        end
    end
endmodule