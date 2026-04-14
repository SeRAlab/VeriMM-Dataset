module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0001;  // Reset the register to 1
        end else begin
            q <= {q[2] ^ q[3], q[3:1]};  // Update LFSR
        end
    end

endmodule