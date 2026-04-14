module JK_FF (
    input J,
    input K,
    input clk,
    input reset,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            Q <= 0;
        else if (J && ~K) 
            Q <= 1;
        else if (~J && K) 
            Q <= 0;
        else if (J && K) 
            Q <= ~Q; // Toggle
    end
endmodule