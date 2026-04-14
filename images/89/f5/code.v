module top_module( 
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output [2:0] final_output
);// Bitwise OR module
    reg [2:0] or_bitwise;
    always @* begin
        or_bitwise = a | b;
    end
    assign out_or_bitwise = or_bitwise;
    
    // Logical OR module
    reg or_logical;
    always @* begin
        or_logical = (a != 0) || (b != 0);
    end
    assign out_or_logical = or_logical;
    
    // NOT module for a
    reg [2:0] not_a;
    always @* begin
        not_a[0] = ~a[0];
        not_a[1] = ~a[1];
        not_a[2] = ~a[2];
    end
    
    // NOT module for b
    reg [2:0] not_b;
    always @* begin
        not_b[0] = ~b[0];
        not_b[1] = ~b[1];
        not_b[2] = ~b[2];
    end
    
    // Combine NOT modules to create out_not
    reg [5:0] out_not_reg;
    always @* begin
        out_not_reg[0] = 1'b0;
        out_not_reg[1] = 1'b0;
        out_not_reg[2] = not_b[0];
        out_not_reg[3] = not_b[1];
        out_not_reg[4] = not_b[2];
        out_not_reg[5] = not_a[0];
    end
    assign out_not = out_not_reg;
    
    // 2's complement operation
    reg [2:0] twos_complement;
    always @* begin
        twos_complement = or_bitwise + 3'b001;
    end
    
    // Invert final output
    reg [2:0] final_output_reg;
    always @* begin
        final_output_reg = ~twos_complement;
    end
    assign final_output = final_output_reg;

endmodule