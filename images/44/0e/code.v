module top_module (
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 3'b000;
        end else begin
            q <= {~q[0], q[2:1]};
        end
    end

endmodule