module top_module (
    input clk,
    input reset,
    output reg [2:0] q
);

    // Johnson counter logic
    always @(posedge clk) begin
        if (reset)
            q <= 3'b000;
        else
            q <= {~q[0], q[2:1]};
    end

endmodule