module phase_detector(
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] out
);
    always @(*) begin
        if (A == B) begin
            out = 2'b00; // A equals B
        end else if (A > B) begin
            out = 2'b01; // A is leading B
        end else begin
            out = 2'b10; // A is lagging B
        end
    end
endmodule