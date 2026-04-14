module top_module(
    input clk,
    input [3:0] a,
    input [3:0] b,
    input sub,
    input cin,
    output reg cout,
    output reg overflow,
    output reg [3:0] sum
);reg [3:0] a_reg, b_reg, sum_reg;
reg sub_reg, cin_reg;
wire [4:0] add_out; // Changed size to accommodate carry
wire [4:0] sub_out; // Changed size to accommodate borrow

assign add_out = a_reg + b_reg + cin_reg;
assign sub_out = a_reg - b_reg - cin_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    sub_reg <= sub;
    cin_reg <= cin;
end

always @(posedge clk) begin
    if (sub_reg) begin
        sum_reg <= sub_out[3:0]; // Assign only 4 bits for sum
    end else begin
        sum_reg <= add_out[3:0]; // Assign only 4 bits for sum
    end
end

always @(posedge clk) begin
    if (sum_reg > 15 || sum_reg < 0) begin // Adjusted condition for overflow
        overflow <= 1;
    end else begin
        overflow <= 0;
    end
end

always @(posedge clk) begin
    if (sub_reg) begin
        cout <= sub_out[4]; // Output carry from subtraction
    end else begin
        cout <= add_out[4]; // Output carry from addition
    end
end

assign sum = sum_reg;

endmodule