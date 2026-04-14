module register (
    input clk,
    input clear,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] Q
);

always @(posedge clk) begin
    if (clear)
        Q <= 8'b0;
    else if (load)
        Q <= parallel_in;
end

endmodule