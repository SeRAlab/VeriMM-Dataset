module top_module (
    input clk,
    input reset,
    input enable,
    output reg [2:0] q
);

    // Binary counter with enable logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 3'b000;
        else if (enable)
            q <= q + 1;
    end

endmodule