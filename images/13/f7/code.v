module A_star_Evaluator(
    input [3:0] H,
    input [3:0] C,
    input EN,
    output reg [4:0] E
);
    always @(*) begin
        if (EN)
            E = H + C;
        else
            E = 5'b0; // Output zero if not enabled
    end
endmodule