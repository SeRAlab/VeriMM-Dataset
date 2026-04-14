module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;  // Reset the counter to '000'
        end else begin
            q <= {~q[0], q[2:1]};  // Johnson counter behavior
        end
    end

endmodule