module mux32to1 (
    input [31:0] d,         // 32 data inputs
    input [4:0] s,          // 5 select lines
    output reg y            // output
);
    always @(*) begin
        y = d[s];            // Select the corresponding data input
    end
endmodule