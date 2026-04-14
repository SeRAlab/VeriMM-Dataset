module top_module(
    input D,
    input Q,
    output reg pulse
);reg D_prev;

always @(posedge Q) begin
    if (D == 1'b1 && D_prev == 1'b0) begin
        pulse <= 1'b1;
    end else begin
        pulse <= 1'b0;
    end
    D_prev <= D;
end

endmodule