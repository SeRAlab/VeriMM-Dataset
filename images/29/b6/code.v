module mux32to1 (
    input [31:0] d,
    input [4:0] s,
    output reg y
);
    always @(*) begin
        y = d[s];
    end
endmodule