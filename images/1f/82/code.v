module slam_update (
    input wire clk,
    input wire reset,
    input wire [7:0] dx,
    input wire [7:0] dy,
    output reg [7:0] x,
    output reg [7:0] y
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 8'b0;
            y <= 8'b0;
        end else begin
            x <= x + dx;
            y <= y + dy;
        end
    end
endmodule