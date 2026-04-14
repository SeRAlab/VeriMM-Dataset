module T_latch (
    input wire D,
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) 
            Q <= D;
        // If T is low, Q retains its previous value
    end
endmodule