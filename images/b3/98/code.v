module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk,                  // Added clock input
    output reg C
);reg [3:0] A_abs, B_abs;
reg [3:0] A_mag, B_mag;

// Pipeline Stage 1: Absolute Value Calculation
always @(*) begin
    if (A[3] == 1'b1) begin
        A_abs = ~A + 1;
    end else begin
        A_abs = A;
    end
    
    if (B[3] == 1'b1) begin
        B_abs = ~B + 1;
    end else begin
        B_abs = B;
    end
end

// Pipeline Stage 2: Magnitude Calculation
always @(*) begin
    if (A_abs > B_abs) begin
        A_mag = A_abs;
        B_mag = B_abs;
    end else begin
        A_mag = B_abs;
        B_mag = A_abs;
    end
end

// Pipeline Stage 4: Comparison
always @(posedge clk) begin
    if (A_mag >= B_mag) begin
        C <= 1'b1;
    end else begin
        C <= 1'b0;
    end
end

endmodule