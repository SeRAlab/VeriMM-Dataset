module shift_register(
    input clk,
    input load,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (load) begin
            q <= d;  // Load new data
        end else begin
            q <= {q[2:0], 1'b0};  // Shift left
        end
    end
endmodule