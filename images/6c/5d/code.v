module register_8bit(
    input clk,
    input clear,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (clear) begin
        q <= 8'b00000000;
    end else if (load) begin
        q <= d;
    end
end

endmodule