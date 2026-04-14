module tap_controller (
    input VPWR,
    input VGND,
    output reg tap_output
);

always @(*) begin
    if (VPWR && !VGND) begin
        tap_output = 0;
    end else if (!VPWR && VGND) begin
        tap_output = 1;
    end
end

endmodule