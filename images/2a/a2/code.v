module d_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @ (D or E) begin
        if (E) 
            Q <= D; // set Q to D when E is high
    end
endmodule