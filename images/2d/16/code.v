module mux32to1 (
    input [31:0] in,        // 32 input lines
    input [4:0] sel,       // 5-bit selection signal
    output reg out         // output
);
    always @(*) begin
        out = in[sel];      // Select the input based on the selection signal
    end
endmodule