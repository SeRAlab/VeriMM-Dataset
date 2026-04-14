module top_module(
    input wire clk,      // Added the clk input
    input [2:0] a,
    input [2:0] b,
    output reg gt,
    output reg eq,
    output reg lt
);reg [2:0] a_reg;
reg [2:0] b_reg;
reg [2:0] a_next;
reg [2:0] b_next;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

always @(posedge clk) begin
    a_next <= a_reg;
    b_next <= b_reg;
end

always @(posedge clk) begin
    if (a_next > b_next) begin
        gt <= 1;
        eq <= 0;
        lt <= 0;
    end else if (a_next == b_next) begin
        gt <= 0;
        eq <= 1;
        lt <= 0;
    end else begin
        gt <= 0;
        eq <= 0;
        lt <= 1;
    end
end

endmodule