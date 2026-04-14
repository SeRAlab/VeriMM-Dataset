module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] result
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if (B >= 4) begin
        stage1_out = 4'b0000; // if shifting by 4 or more, result is zero (no wrap around)
    end else begin
        stage1_out = (B[3] == 1'b0) ? (A << B) : (A >> B[2:0]); // use B[2:0] for right shift to avoid negative shift
    end
end

always @(*) begin
    stage2_out = stage1_out;
end

assign result = stage2_out;

endmodule