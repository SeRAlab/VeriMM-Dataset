module top_module(
    input clk, // clock input
    input rst, // synchronous reset input
    input en, // synchronous enable input
    output reg [3:0] Q // 4-bit binary output
);always @(posedge clk) begin
        if (rst) // reset counter to 0
            Q <= 4'b0000;
        else if (en) // increment counter
            Q <= Q + 4'b0001;
    end
    
endmodule