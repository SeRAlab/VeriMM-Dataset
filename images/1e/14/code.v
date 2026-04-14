module T_flip_flop(
    input wire T,
    input wire EN,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (EN) begin
            if (T)
                Q <= ~Q; // Toggle the output
        end
    end
endmodule