module register_with_clear (
    input clk,
    input clr,
    input [4:0] d,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (clr) begin
            q <= 5'b00000;
        end else begin
            q <= d;
        end
    end

endmodule