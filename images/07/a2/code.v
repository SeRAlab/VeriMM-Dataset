module fir_filter (
    input clk,
    input rst,
    input [3:0] x_in,
    output reg [7:0] y_out
);
    reg [3:0] x [0:3]; // 4 previous samples
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 8'b0;
            for (i = 0; i < 4; i = i + 1) begin
                x[i] <= 4'b0;
            end
        end else begin
            // Shift samples
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            // Calculate output using FIR coefficients [1, 2, 3, 4]
            y_out <= (x[0] * 1) + (x[1] * 2) + (x[2] * 3) + (x[3] * 4);
        end
    end
endmodule