module top_module(
    output reg SB_DFF_REG,  // Change output type to reg
    input C, E, S, D
);always @(negedge C) begin
        if (E) begin
            if (S)
                SB_DFF_REG <= 1;
            else
                SB_DFF_REG <= D;
        end
    end

endmodule