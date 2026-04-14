module top_module(
    Q,
    CLK,
    D,
    SCD,
    SCE,
    SET_B
);output reg Q;  // Change Q to output reg to allow assignment in always block
    input CLK;
    input D;
    input SCD;
    input SCE;
    input SET_B;

    reg SET_reg;
    reg SCE_reg;
    reg D_reg;
    reg SCD_reg;

    always @(posedge CLK) begin
        SET_reg <= SET_B;
        SCE_reg <= SCE;
        D_reg <= D;
        SCD_reg <= SCD;
        
        // Update Q based on the next logic
        if (SET_reg) begin
            Q <= 1;
        end
        else if (!SCE_reg) begin
            Q <= 0;
        end
        else if (D_reg != SCD_reg) begin
            Q <= D_reg;
        end
    end

endmodule