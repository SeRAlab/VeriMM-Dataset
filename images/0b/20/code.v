module SR_FF (
    input wire S,      // Set input
    input wire R,      // Reset input
    input wire clk,    // Clock input
    output reg Q,      // Output Q
    output reg Qn      // Output not Q
);
    
    always @(posedge clk or posedge S or posedge R) begin
        if (S) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end
    end
endmodule