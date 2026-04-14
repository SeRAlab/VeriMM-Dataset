module top_module(
    input clk,
    input a,
    output reg out_comb_ff,
    output reg [1:0] out_counter
);reg [1:0] counter;

always @(posedge clk) begin
    counter <= counter + 1;
end

assign out_counter = counter;

always @(a) begin
    out_comb_ff <= a ^ out_comb_ff;
end

endmodule