module shift_register (
    input clk,
    input rst,
    input shift_left,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'd0;
        end else if (shift_left) begin
            q <= {q[2:0], 1'b0};
        end else begin
            q <= {1'b0, q[3:1]};
        end
    end

endmodule