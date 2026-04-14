module top_module(
    input a, 
    input b,
    input c,
    input reset,
    output wire out_assign,
    output reg out_alwaysblock
);// Majority gate using assign statements
    assign out_assign = (a & b) | (a & c) | (b & c);
    
    // Majority gate using a combinational always block
    always @(*) begin
        if (a & b & c) begin
            out_alwaysblock <= 1'b1;
        end else if (a & b) begin
            out_alwaysblock <= 1'b1;
        end else if (a & c) begin
            out_alwaysblock <= 1'b1;
        end else if (b & c) begin
            out_alwaysblock <= 1'b1;
        end else begin
            out_alwaysblock <= 1'b0;
        end
    end
    
    // Synchronous reset input
    always @(posedge reset) begin
        out_alwaysblock <= 1'b0;
    end

endmodule