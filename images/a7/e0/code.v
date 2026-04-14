module top_module (
    input clk,
    input reset,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q <= {q[2:0], data};
        end
    end

endmodule