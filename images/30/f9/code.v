module data_forwarding_unit (
    input [31:0] source1,
    input [31:0] source2,
    input forwardA,
    input forwardB,
    output reg [31:0] data_out
);

always @(*) begin
    if (forwardA) begin
        data_out = source1;
    end else if (forwardB) begin
        data_out = source2;
    end else begin
        data_out = 32'b0; // Default output
    end
end

endmodule