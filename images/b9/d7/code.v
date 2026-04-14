module register (
    input clk,
    input clear,
    input [7:0] d,
    output reg [7:0] q
);

    // Register logic
    always @(posedge clk or posedge clear) begin
        if (clear)
            q <= 8'b00000000;
        else
            q <= d;
    end

endmodule