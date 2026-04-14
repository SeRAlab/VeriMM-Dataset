module top_module(
    input D, C, CE, S,
    output reg Q
);always @ (posedge C) begin
    if (CE) begin
        if (S) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
end

endmodule