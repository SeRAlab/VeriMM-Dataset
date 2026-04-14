module mux32to1 (
    input [31:0] in,    // 32 input lines
    input [4:0] sel,    // 5 selection lines
    output reg out       // Output line
);
    always @(*) begin
        out = in[sel];    // Select input based on sel
    end
endmodule