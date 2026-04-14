module rectangle_area(
    input [7:0] length,
    input [7:0] width,
    output reg [15:0] area
);

    always @(*) begin
        area = length * width;
    end

endmodule