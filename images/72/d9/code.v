module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk,             // Added clk input
    output reg C
);reg signed [3:0] A_reg1, B_reg1;
reg signed [3:0] A_reg2, B_reg2;
reg signed [3:0] A_reg3, B_reg3;

always @(*) begin
    A_reg1 = A;
    B_reg1 = B;
end

always @(posedge clk) begin
    A_reg2 <= A_reg1;     // Changed to non-blocking assignment
    B_reg2 <= B_reg1;     // Changed to non-blocking assignment
end

always @(posedge clk) begin
    A_reg3 <= A_reg2;     // Changed to non-blocking assignment
    B_reg3 <= B_reg2;     // Changed to non-blocking assignment
end

always @(posedge clk) begin
    if (A_reg3 >= B_reg3) begin
        C <= 1;
    end else begin
        C <= 0;
    end
end

endmodule