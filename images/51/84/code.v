module top_module(
    y, cb, cr,
    red, green, blue,
    clk
);input clk;

input [7:0] y, cb, cr;
output reg [7:0] red, green, blue;

// offset the inputs
reg signed [8:0] adj_y, adj_cb, adj_cr;
always @(posedge clk) begin
    adj_y <= y;
    adj_cr <= cr - 8'd128;
    adj_cb <= cb - 8'd128;
end

// scaling constants from standard formulas
// nominal Y is 16 to 235
// nominal C's are 16-240 with 128 at zero
wire signed [8:0] const0 = 9'd128; // 1 * 128
wire signed [8:0] const1 = 9'd179; // 1.402 * 128
wire signed [8:0] const2 = - 9'd91; // 0.714136 * 128 
wire signed [8:0] const3 = - 9'd44; // 0.344136 * 128
wire signed [8:0] const4 = 9'd227; // 1.772 * 128

// multipliers - 9x9 is a natural building block
reg signed [17:0] product_a, product_b, product_c, 
    product_d, product_e;
always @(posedge clk) begin
    product_a <= const0 * adj_y;
    product_b <= const1 * adj_cr;
    product_c <= const2 * adj_cr;
    product_d <= const3 * adj_cb;
    product_e <= const4 * adj_cb;
end

// summation - 17 selected by simulation
reg signed [17:0] sum_red, sum_green, sum_blue;
always @(posedge clk) begin
    sum_red <= product_a + product_b;
    sum_green <= product_a + product_c + product_d;
    sum_blue <= product_a + product_e;
end

// saturation
always @(posedge clk) begin
    if (sum_red[17] == 1) begin
        red <= 8'h0;
    end else if (sum_red[16:15] == 2'b11) begin
        red <= 8'hff;
    end else begin
        red <= sum_red[14:7];
    end

    if (sum_green[17] == 1) begin
        green <= 8'h0;
    end else if (sum_green[16:15] == 2'b11) begin
        green <= 8'hff;
    end else begin
        green <= sum_green[14:7];
    end

    if (sum_blue[17] == 1) begin
        blue <= 8'h0;
    end else if (sum_blue[16:15] == 2'b11) begin
        blue <= 8'hff;
    end else begin
        blue <= sum_blue[14:7];
    end
end

endmodule