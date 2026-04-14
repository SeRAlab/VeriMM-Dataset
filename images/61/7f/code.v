module reg_8bit (
    input clk,
    input reset,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

    // Register logic
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (load)
            q <= d;
    end

endmodule