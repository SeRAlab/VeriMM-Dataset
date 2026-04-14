module barrel_shifter(
    input [1:0] in,
    input ctrl,
    output reg [1:0] out
);
    always @(*) begin
        if (ctrl) begin
            out = {in[0], in[1]}; // Shift left and wrap around
        end else begin
            out = in; // No shift
        end
    end
endmodule