module binary_counter (
    input clk,
    output reg [3:0] Q
);

always @(posedge clk) begin
    if (Q == 4'b1111) begin
        Q <= 4'b0000;
    end else begin
        Q <= Q + 1;
    end
end

endmodule