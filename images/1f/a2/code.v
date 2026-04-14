module priority_encoder (
    input wire A,
    input wire B,
    input wire C,
    output reg [1:0] out,
    output reg valid
);
    always @(*) begin
        if (A) begin
            out = 2'b00; // A has the highest priority
            valid = 1'b1;
        end else if (B) begin
            out = 2'b01; // B has the second priority
            valid = 1'b1;
        end else if (C) begin
            out = 2'b10; // C has the lowest priority
            valid = 1'b1;
        end else begin
            out = 2'b11; // no valid input
            valid = 1'b0;
        end
    end
endmodule