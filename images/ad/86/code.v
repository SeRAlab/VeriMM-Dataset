module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk,                       // Added clk input
    output equal,
    output greater_than,
    output less_than
);reg signed [3:0] A_reg, B_reg;
reg equal_reg, greater_than_reg, less_than_reg;
wire signed [3:0] A_pipe1, B_pipe1;
wire signed [3:0] A_pipe2, B_pipe2;

assign equal = equal_reg;
assign greater_than = greater_than_reg;
assign less_than = less_than_reg;

// Pipeline stage 1
assign A_pipe1 = A_reg;
assign B_pipe1 = B_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

// Pipeline stage 2
assign A_pipe2 = A_pipe1;
assign B_pipe2 = B_pipe1;

always @(posedge clk) begin
    if (A_pipe2 == B_pipe2) begin
        equal_reg <= 1'b1;
        greater_than_reg <= 1'b0;
        less_than_reg <= 1'b0;
    end else if (A_pipe2 > B_pipe2) begin
        equal_reg <= 1'b0;
        greater_than_reg <= 1'b1;
        less_than_reg <= 1'b0;
    end else begin
        equal_reg <= 1'b0;
        greater_than_reg <= 1'b0;
        less_than_reg <= 1'b1;
    end
end

endmodule