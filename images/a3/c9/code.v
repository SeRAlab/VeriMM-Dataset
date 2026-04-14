module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    input clk,           // Added the clk input
    output reg [3:0] Q
);reg [3:0] sum_reg;
reg [3:0] sub_reg;

always @ (posedge clk) begin
    if (C == 1'b1) begin // Addition
        sum_reg <= A + B;
    end else begin // Subtraction
        sub_reg <= A - B;
    end
end

always @ (posedge clk) begin
    if (C == 1'b1) begin // Addition
        Q <= sum_reg;
    end else begin // Subtraction
        Q <= sub_reg;
    end
end

endmodule