module bidirectional_shift_register (
    input clk,
    input reset,
    input enable,
    input dir,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end else if (enable) begin
            if (dir) begin
                q <= {q[0], q[15:1]};
            end else begin
                q <= {q[14:0], q[15]};
            end
        end
    end

endmodule