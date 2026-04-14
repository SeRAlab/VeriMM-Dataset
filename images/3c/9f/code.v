module a_star_heuristic (
    input [3:0] g,
    input [3:0] f,
    output reg [3:0] h
);
    always @(*) begin
        // Check for underflow and compute h = f - g
        if (f >= g) 
            h = f - g;
        else 
            h = 4'b0000; // Underflow case, return 0
    end
endmodule