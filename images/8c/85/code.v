module top_module(
    input [3:0] A,
    input [3:0] B,
    input ctrl,
    input clk,        // Added clk input
    output reg [3:0] Y
);reg [3:0] sum_reg;
reg [3:0] diff_reg;

always @ (posedge clk) begin
    if (ctrl == 1'b1) begin
        sum_reg <= A + B;
    end else begin
        diff_reg <= A - B;
    end
end

always @ (posedge clk) begin
    if (ctrl == 1'b1) begin
        Y <= sum_reg;
    end else begin
        Y <= diff_reg;
    end
end

endmodule