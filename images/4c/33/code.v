module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    input clk,  // Added clock input
    output reg [3:0] Q
);reg [3:0] A_reg, B_reg, Q_reg;
reg mode_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    mode_reg <= mode;
end

always @ (posedge clk) begin
    if (mode_reg == 0) begin
        Q_reg <= A_reg + B_reg;
    end else begin
        Q_reg <= A_reg - B_reg;
    end
end

assign Q = Q_reg;

endmodule