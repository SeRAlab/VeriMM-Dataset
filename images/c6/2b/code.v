module adder_subtractor (input [15:0] A, B, input C, CLK, output reg [15:0] R);

always @(posedge CLK) begin
    if (C == 0) // addition
        R <= A + B;
    else // subtraction
        R <= A - B;
end

endmodule