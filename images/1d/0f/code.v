module DLatch (
    input wire D,
    input wire E,
    output reg Q
);
    always @(D or E) begin
        if (E) 
            Q <= D;
        // When E is low, Q retains the previous value
    end
endmodule