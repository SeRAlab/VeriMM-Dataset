module shift_register (
    input [7:0] d,
    input clk,
    input load,
    input shift,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end else if (shift) begin
            q <= {q[6:0], 1'b0};
        end
    end

endmodule