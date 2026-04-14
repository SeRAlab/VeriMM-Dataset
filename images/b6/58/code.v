module top_module(
    input clk,
    input reset_n,
    output reg [3:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 4'b0001;  // Asynchronous reset to a non-zero initial state
        end else begin
            q <= {q[2:0], q[3] ^ q[0]};  // LFSR with x^4 + x + 1
        end
    end

endmodule