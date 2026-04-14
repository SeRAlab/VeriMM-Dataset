module a_star_cost (
    input [7:0] g,
    input [7:0] h,
    input enable,
    output reg [7:0] f
);
    always @(*) begin
        if (enable) 
            f = g + h;
        else 
            f = 8'b0; // Output 0 when not enabled
    end
endmodule