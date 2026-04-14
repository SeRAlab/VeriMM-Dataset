module sobel_edge_detection(
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output reg [7:0] edge_intensity
);

    wire signed [16:0] Gx, Gy;
    wire signed [16:0] magnitude;

    // Compute Gx
    assign Gx = pixel00 * -1 + pixel02 * 1 + 
                pixel10 * -2 + pixel12 * 2 +
                pixel20 * -1 + pixel22 * 1;

    // Compute Gy
    assign Gy = pixel00 * -1 + pixel01 * -2 + pixel02 * -1 + 
                pixel20 * 1 + pixel21 * 2 + pixel22 * 1;

    // Compute the magnitude
    assign magnitude = $signed(Gx) + $signed(Gy);
    
    // Normalize the output to an 8-bit number
    always @(*) begin
        if(magnitude < 0)
            edge_intensity = 0;
        else if(magnitude > 255)
            edge_intensity = 255;
        else
            edge_intensity = magnitude[7:0];
    end
endmodule