module T_latch (
    input wire T,
    input wire enable,
    output reg Q
);
    always @ (T or enable) begin
        if (enable) begin
            if (T) begin
                Q <= ~Q; // Toggle the output
            end
        end
    end
endmodule