module d_ff_sr (
    input clk,
    input set,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (set)
            q <= 1'b1;
        else
            q <= d;
    end
endmodule