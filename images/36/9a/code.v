module mux32to1 (
    input [31:0] in,  // 32 input lines
    input [4:0] sel,  // 5-bit select line
    output reg out     // output line
);
    always @(*) begin
        out = in[sel];   // select the input line based on the select line
    end
endmodule