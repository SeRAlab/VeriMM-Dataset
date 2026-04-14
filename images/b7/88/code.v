module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input signed [3:0] A,
    input signed [3:0] B,
    output reg [15:0] count
);reg [3:0] A_mag;
    reg [3:0] B_mag;
    reg cmp_out;
    
    // Signed Magnitude Comparator
    always @* begin
        if (A[3] == 1 && B[3] == 0) begin
            cmp_out = 0;
        end else if (A[3] == 0 && B[3] == 1) begin
            cmp_out = 1;
        end else if (A >= B) begin
            cmp_out = 1;
        end else begin
            cmp_out = 0;
        end
    end
    
    // 16-bit Counter
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (cmp_out) begin
            count <= count + 1;
        end
    end
    
endmodule