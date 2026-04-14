module kmeans_distance (
    input [4:0] x1, y1,
    input [4:0] x2, y2,
    input [4:0] x3, y3,
    input [4:0] x_ref, y_ref,
    output reg [7:0] distance1,
    output reg [7:0] distance2,
    output reg [7:0] distance3
);
    wire [5:0] dx1, dy1, dx2, dy2, dx3, dy3;
    assign dx1 = x1 - x_ref;
    assign dy1 = y1 - y_ref;
    assign dx2 = x2 - x_ref;
    assign dy2 = y2 - y_ref;
    assign dx3 = x3 - x_ref;
    assign dy3 = y3 - y_ref;
    
    always @(*) begin
        distance1 = dx1 * dx1 + dy1 * dy1;
        distance2 = dx2 * dx2 + dy2 * dy2;
        distance3 = dx3 * dx3 + dy3 * dy3;
    end
endmodule