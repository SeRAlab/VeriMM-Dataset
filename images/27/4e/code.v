module mux32to1 (
    input [31:0] in,  // 32 input signals
    input [4:0] sel,  // 5-bit select signal
    output reg out     // Output signal
);
    always @(*) begin
        out = in[sel];   // Select the input based on the select line
    end
endmodule