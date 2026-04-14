module addsub (
    input [3:0] A,
    input [3:0] B,
    input ctrl,
    output reg [3:0] Y
);

    always @(*) begin
        if (ctrl) begin
            Y <= A + B;
        end else begin
            Y <= A - B;
        end
    end

endmodule