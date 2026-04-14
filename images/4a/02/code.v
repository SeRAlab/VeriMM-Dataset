module top_module(
    input clk,
    input load,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= d;
    end

endmodule