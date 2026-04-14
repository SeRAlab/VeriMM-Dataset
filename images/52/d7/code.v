module decoder3to8(a, y);
    input [2:0] a;
    output [7:0] y;
    reg [7:0] y;

    always @(a) begin
        y = 8'b00000000;
        y[a] = 1'b1;
    end
endmodule