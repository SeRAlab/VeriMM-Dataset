module top_module(
    input clk,
    input reset_n,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            q <= 5'b00001;  // Synchronous reset to initial state
        end else begin
            q <= {q[3:0], q[4]};  // Ring shift
        end
    end

endmodule