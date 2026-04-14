module nearest_neighbor_interpolation (
    input [3:0] pixel00, // top-left
    input [3:0] pixel01, // top-right
    input [3:0] pixel10, // bottom-left
    input [3:0] pixel11, // bottom-right
    output reg [3:0] out00, // 4x4 output corresponding to pixel00
    output reg [3:0] out01, // 4x4 output corresponding to pixel01
    output reg [3:0] out10, // 4x4 output corresponding to pixel10
    output reg [3:0] out11  // 4x4 output corresponding to pixel11
);
    always @* begin
        out00 = pixel00; // replicate pixel00
        out01 = pixel01; // replicate pixel01
        out10 = pixel10; // replicate pixel10
        out11 = pixel11; // replicate pixel11
    end
endmodule