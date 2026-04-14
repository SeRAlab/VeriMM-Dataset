module dff_with_enable(
    input clk,
    input reset,
    input enable,
    input d,
    output reg q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0; // Asynchronous reset
        else if (enable)
            q <= d; // Follow input d when enable is high
    end

endmodule