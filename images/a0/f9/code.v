module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input clk,          // Added the clk input
    output eq,
    output lt,
    output gt,
    output overflow
);reg signed [7:0] A_reg, B_reg, diff_reg;
    reg [2:0] stage;
    wire signed [7:0] diff;  // Changed to signed for accurate comparison
    wire msb_A, msb_B, msb_diff;
    
    assign eq = (diff == 0);
    assign lt = (msb_diff == 1) && (msb_A == 0); // Adjusted lt condition for correct comparison
    assign gt = (msb_diff == 0) && (msb_A == 1); // Adjusted gt condition for correct comparison
    assign overflow = ((msb_A != msb_B) && (msb_A != msb_diff));
    
    always @(posedge clk) begin
        case (stage)
            3'b000: begin
                A_reg <= A;
                B_reg <= B;
                stage <= 3'b001;
            end
            3'b001: begin
                diff_reg <= A_reg - B_reg;
                stage <= 3'b010;
            end
            3'b010: begin
                A_reg <= A;
                B_reg <= B;
                stage <= 3'b011;
            end
            3'b011: begin
                diff_reg <= A_reg - B_reg;
                stage <= 3'b000;
            end
        endcase
    end
    
    assign diff = (stage == 3'b001) ? diff_reg : A - B; // Fixed stage comparison to match 3-bit representation
    assign msb_A = A[7];
    assign msb_B = B[7];
    assign msb_diff = diff[7];
    
endmodule