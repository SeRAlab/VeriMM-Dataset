module mux4to1 (
    input [3:0] in,
    input [1:0] sel,
    output reg out
);

    wire sel0_inv, sel1_inv;

    assign sel0_inv = ~sel[0];
    assign sel1_inv = ~sel[1];

    always @(*) begin
        if (sel == 2'b00) begin
            out = in[0];
        end else if (sel == 2'b01) begin
            out = in[1];
        end else if (sel == 2'b10) begin
            out = in[2];
        end else begin
            out = in[3];
        end
    end

endmodule