module nearest_neighbor_interpolation (
    input [7:0] pixel00, // lower resolution pixel (0,0)
    input [7:0] pixel01, // lower resolution pixel (0,1)
    input [7:0] pixel10, // lower resolution pixel (1,0)
    input [7:0] pixel11, // lower resolution pixel (1,1)
    output [7:0] out00, // higher resolution pixel (0,0)
    output [7:0] out01, // higher resolution pixel (0,1)
    output [7:0] out02, // higher resolution pixel (0,2)
    output [7:0] out03, // higher resolution pixel (0,3)
    output [7:0] out10, // higher resolution pixel (1,0)
    output [7:0] out11, // higher resolution pixel (1,1)
    output [7:0] out12, // higher resolution pixel (1,2)
    output [7:0] out13, // higher resolution pixel (1,3)
    output [7:0] out20, // higher resolution pixel (2,0)
    output [7:0] out21, // higher resolution pixel (2,1)
    output [7:0] out22, // higher resolution pixel (2,2)
    output [7:0] out23, // higher resolution pixel (2,3)
    output [7:0] out30, // higher resolution pixel (3,0)
    output [7:0] out31, // higher resolution pixel (3,1)
    output [7:0] out32, // higher resolution pixel (3,2)
    output [7:0] out33  // higher resolution pixel (3,3)
);

assign out00 = pixel00;
assign out01 = pixel00;
assign out02 = pixel01;
assign out03 = pixel01;

assign out10 = pixel00;
assign out11 = pixel00;
assign out12 = pixel01;
assign out13 = pixel01;

assign out20 = pixel10;
assign out21 = pixel10;
assign out22 = pixel11;
assign out23 = pixel11;

assign out30 = pixel10;
assign out31 = pixel10;
assign out32 = pixel11;
assign out33 = pixel11;

endmodule