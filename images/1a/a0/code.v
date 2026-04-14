module cholesky_decomposition (
    input wire clk,
    input wire rst,
    input wire [15:0] a11,
    input wire [15:0] a12,
    input wire [15:0] a22,
    output reg [15:0] l11,
    output reg [15:0] l12,
    output reg [15:0] l22,
    output reg done
);

reg [15:0] temp_a12;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        l11 <= 16'b0;
        l12 <= 16'b0;
        l22 <= 16'b0;
        done <= 1'b0;
    end else begin
        l11 <= a11; // l11 = a11
        l12 <= a12; // l12 = a12
        l22 <= a22 - (l12 * l12) / l11; // l22 = a22 - l12^2 / l11
        done <= 1'b1; // Indicate that computation is done
    end
end

endmodule