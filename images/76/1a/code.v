module ShiftRegister (
    input clk,
    input reset,
    input load,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= d;
        end else begin
            q <= {q[2:0], 1'b0};
        end
    end
endmodule