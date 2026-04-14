module top_module(
    input [3:0] a,
    input [3:0] b,
    input select,
    input clk,  // Added clk as an input
    output reg [3:0] out
);wire [3:0] xor_out;
wire [3:0] xnor_out;

assign xor_out = {a[3]^b[3], a[2]^b[2], a[1]^b[1], a[0]^b[0]};
assign xnor_out = ~xor_out;

always @(posedge clk) begin
    if (select) begin
        out <= xnor_out;
    end else begin
        out <= xor_out;
    end
end

endmodule