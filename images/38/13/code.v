module butterworth_filter (
    input clk,
    input reset,
    input [3:0] x,
    output reg [3:0] y
);

reg [3:0] x_reg1, x_reg2;
reg [3:0] y_reg1, y_reg2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        x_reg1 <= 4'b0000;
        x_reg2 <= 4'b0000;
        y_reg1 <= 4'b0000;
        y_reg2 <= 4'b0000;
        y <= 4'b0000;
    end else begin
        x_reg2 <= x_reg1;
        x_reg1 <= x;
        y_reg2 <= y_reg1;
        y_reg1 <= y;
        y <= (x + x_reg1 + y_reg1 + y_reg2) >> 2; // Implementing the equation
    end
end

endmodule