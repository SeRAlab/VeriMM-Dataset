module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input signed_ctrl,
    input clk, // Added clk input
    output signed [15:0] result
);// Pipeline registers
reg signed [7:0] a_reg, b_reg;
reg signed_ctrl_reg;
reg signed [15:0] partial_sum_reg [0:2];

// Wallace tree multiplier components
wire signed [7:0] a1, b1, a2, b2, a3, b3;
wire signed [11:0] p1, p2, p3, p4, p5;
wire signed [15:0] s1, s2, s3;

// Assign inputs to pipeline registers
always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    signed_ctrl_reg <= signed_ctrl;
end

// Stage 1
assign a1 = a_reg;
assign b1 = signed_ctrl_reg ? b_reg : {1'b0, b_reg[6:0]};
assign p1 = a1 * b1;
assign s1 = {p1[5:0], 4'b0};

// Stage 2
assign a2 = a_reg;
assign b2 = signed_ctrl_reg ? {1'b0, b_reg[7:0]} : b_reg;
assign p2 = a2 * b2;
assign s2 = {p2[5:0], 4'b0};

// Stage 3
assign a3 = a_reg;
assign b3 = signed_ctrl_reg ? {1'b0, b_reg[7:1]} : {1'b0, b_reg[6:0]};
assign p3 = a3 * b3;
assign p4 = a3 * b2;
assign p5 = a1 * b3;
assign s3 = {p3[8:3], p4[8:3], p5[8:3]};

// Stage 4
always @(posedge clk) begin
    partial_sum_reg[0] <= s1;
    partial_sum_reg[1] <= s2;
    partial_sum_reg[2] <= s3;
end

// Final stage
assign result = partial_sum_reg[0] + partial_sum_reg[1] + partial_sum_reg[2];

endmodule