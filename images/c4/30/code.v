module binary_counter (
    input clk,
    input reset,      // Asynchronous active-high reset
    output reg [3:0] q);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (q == 4'b1111) begin
            q <= 4'b0000;
        end else begin
            q <= q + 1;
        end
    end
    
endmodule

module top_module (
    input clk,
    input reset,      // Asynchronous active-high reset
    output [3:0] q);
    
    binary_counter counter(
        .clk(clk),
        .reset(reset),
        .q(q)
    );
    
endmodule