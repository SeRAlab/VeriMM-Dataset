module crystal_oscillator (
    input wire clk_in,
    input wire rst,
    input wire [3:0] DIV_FACTOR,
    output reg clk_out
);
    reg [3:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else if (count == DIV_FACTOR - 1) begin
            clk_out <= ~clk_out;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
endmodule