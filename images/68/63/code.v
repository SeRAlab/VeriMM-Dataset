module d_flip_flop (
    input wire d,
    input wire clk,
    input wire reset,
    output reg q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule