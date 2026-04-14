module top_module(
        px, py,
        rgb
    );parameter BUS_WIDTH = 12;
    parameter TOP = 240;
    parameter LEFT = 240;
    parameter BOTTOM = 420;
    parameter RIGHT = 400;
    parameter THICCNESS = 3;

    input wire [9:0] px, py;
    output wire [BUS_WIDTH-1:0] rgb;

    wire isTop = TOP-THICCNESS <= py && py <= TOP+THICCNESS;
    wire isBottom = BOTTOM-THICCNESS <= py && py <= BOTTOM+THICCNESS;
    wire inBoundY = TOP-THICCNESS <= py && py <= BOTTOM+THICCNESS;

    wire isLeft = LEFT-THICCNESS <= px && px <= LEFT+THICCNESS;
    wire isRight = RIGHT-THICCNESS <= px && px <= RIGHT+THICCNESS;
    wire inBoundX = LEFT-THICCNESS <= px && px <= RIGHT+THICCNESS;

    assign rgb = ((inBoundX && (isTop || isBottom)) || (inBoundY && (isLeft || isRight))) ? 15'd3 : 5'd0;

endmodule