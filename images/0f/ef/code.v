module D_latch (
    input wire D,
    input wire enable,
    output reg Q
);
    always @(D or enable) begin
        if (enable) begin
            Q <= D; // Store D when enable is high
        end
        // Q retains its value when enable is low
    end
endmodule