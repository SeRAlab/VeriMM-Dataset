module ShiftRegister (
    input clk,
    input load,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end else begin
            q <= {q[2:0], 1'b0};
        end
    end
endmodule