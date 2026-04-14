module register (
    input [7:0] d,
    input clk,
    input reset,
    output reg [7:0] q
);

    // 8-bit register logic
    always @(posedge clk or negedge reset) begin
        if (~reset)
            q <= 8'b00000000;
        else
            q <= d;
    end

endmodule