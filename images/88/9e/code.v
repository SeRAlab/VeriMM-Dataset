module register_16bit(
    input clk,
    input clr,
    input load,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (clr) begin
        q <= 16'b0000000000000000;
    end else if (load) begin
        q <= d;
    end
end

endmodule