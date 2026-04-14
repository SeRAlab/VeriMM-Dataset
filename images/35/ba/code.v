module mux32to1 (
    input [31:0] data_in,
    input [4:0] sel,
    output reg out
);
    always @(*) begin
        out = data_in[sel];
    end
endmodule