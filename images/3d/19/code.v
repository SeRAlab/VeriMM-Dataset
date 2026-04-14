module SLAMEstimator (
    input clk,
    input rst,
    input [4:0] x_in,
    input [4:0] y_in,
    input new_data,
    output reg [4:0] x_out,
    output reg [4:0] y_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 5'b00000;
            y_out <= 5'b00000;
        end else if (new_data) begin
            x_out <= x_in;
            y_out <= y_in;
        end
    end
endmodule