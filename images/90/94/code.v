module top_module(
    input [3:0] A,
    input [1:0] B,
    input C,
    input areset,
    output [3:0] S
);reg [3:0] shifted;

    always @(*) begin
        if (areset) begin
            shifted <= 4'b0;
        end else begin
            if (C) begin
                // Logical Shift Right
                shifted <= A >> B; // Use shift operator for right shifts
            end else begin
                // Logical Shift Left
                shifted <= A << B; // Use shift operator for left shifts
            end
        end
    end

    assign S = shifted;

endmodule