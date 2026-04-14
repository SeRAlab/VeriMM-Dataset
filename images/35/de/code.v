module T_latch (
    input wire D,
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) 
            Q <= D; // Update Q based on D when T is high
        // If T is low, Q retains its value
    end
endmodule