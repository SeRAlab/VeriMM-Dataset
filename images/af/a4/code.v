module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,              // Added clk input
    output reg greater,     // Changed to reg type for output
    output reg less         // Changed to reg type for output
);reg [3:0] A_reg;
reg [3:0] B_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @(posedge clk) begin
    if (A_reg > B_reg) begin
        greater <= 1'b1;   // Set greater output based on condition
        less <= 1'b0;      // Set less output to false
    end else if (A_reg < B_reg) begin
        greater <= 1'b0;   // Set greater output to false
        less <= 1'b1;      // Set less output based on condition
    end else begin
        greater <= 1'b0;   // Set greater output to false
        less <= 1'b0;      // Set less output to false
    end
end

endmodule