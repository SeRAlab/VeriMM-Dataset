module top_module(
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg [3:0] sum,  // Changed to reg to allow assignments in always block
    output reg cout        // Changed to reg to allow assignments in always block
);reg [3:0] sum_reg;
wire [4:0] sum_wire;
wire overflow;

assign sum_wire = a + b + cin;
assign overflow = sum_wire[4];

always @(posedge clk) begin
    if (rst) begin
        sum_reg <= 0;
        cout <= 0;
    end else begin
        sum_reg <= sum_wire[3:0];
        cout <= overflow;
    end
end

assign sum = sum_reg;

endmodule