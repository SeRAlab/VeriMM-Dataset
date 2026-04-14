module top_module (
    input clk,
    input reset,
    input load,
    input [7:0] load_value,
    output reg [7:0] q
);

    // Binary up-counter with load logic
    always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= load_value;
        else
            q <= q + 1;
    end

endmodule