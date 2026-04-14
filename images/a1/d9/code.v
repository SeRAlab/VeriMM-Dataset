module top_module(
    input clk,
    input reset,
    output reg [5:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the LFSR to 6'b000001
            q <= 6'b000001;
        end else begin
            // LFSR with feedback polynomial x^6 + x + 1
            q <= {q[4:0], q[5] ^ q[0]};
        end
    end

endmodule