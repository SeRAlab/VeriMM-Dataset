module priority_encoder (
    input [3:0] I,
    output V,
    output [1:0] D
);

    assign V = |I; // OR all inputs together to check if any are high
    
    always @* begin
        casez(I) // case statement to determine highest input
            4'b0001: D = 2'b00;
            4'b0010: D = 2'b01;
            4'b0100: D = 2'b10;
            4'b1000: D = 2'b11;
            default: D = 2'b00; // default case if no inputs are high
        endcase
    end

endmodule