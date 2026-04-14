module mux_2_to_1 (
    input wire a,
    input wire b,
    input wire sel,
    output reg out
);
    reg last_out;

    always @(*) begin
        if (sel) begin
            out = b;
            last_out = b;
        end else begin
            out = a;
            last_out = a;
        end
    end
endmodule