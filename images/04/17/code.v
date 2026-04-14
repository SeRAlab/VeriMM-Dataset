module data_forwarding_unit(
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] forwardA,
    input [4:0] forwardB,
    input [31:0] regA_value,
    input [31:0] regB_value,
    output reg [31:0] resultA,
    output reg [31:0] resultB
);
    always @(*) begin
        if (src1 == forwardA) begin
            resultA = regB_value; // Forward value from regB
        end else begin
            resultA = regA_value; // Use regA value
        end

        if (src2 == forwardB) begin
            resultB = regB_value; // Forward value from regB
        end else begin
            resultB = regA_value; // Use regA value
        end
    end
endmodule