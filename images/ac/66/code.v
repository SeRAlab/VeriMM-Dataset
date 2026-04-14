module top_module(
    input clk,
    input reset,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the LFSR to 8'b00000001
            q <= 8'b00000001;
        end else begin
            // LFSR with fixed tap sequence
            q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]};
        end
    end

endmodule