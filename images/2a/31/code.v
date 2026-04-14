module data_forwarding_unit (
    input [4:0] src1,      // Source register 1 from Decode stage
    input [4:0] src2,      // Source register 2 from Decode stage
    input [4:0] dest1,     // Destination register from Execute stage 1
    input [4:0] dest2,     // Destination register from Execute stage 2
    input valid1,          // Valid signal for Execute stage 1
    input valid2,          // Valid signal for Execute stage 2
    output reg forwardA,   // Forwarding signal for src1
    output reg forwardB    // Forwarding signal for src2
);

always @(*) begin
    // Default forwarding signals
    forwardA = 0;
    forwardB = 0;

    // Check for forwarding conditions
    if (valid1 && (src1 == dest1)) begin
        forwardA = 1; // Forward from first EX stage
    end
    if (valid2 && (src1 == dest2)) begin
        forwardA = 1; // Forward from second EX stage
    end
    if (valid1 && (src2 == dest1)) begin
        forwardB = 1; // Forward from first EX stage
    end
    if (valid2 && (src2 == dest2)) begin
        forwardB = 1; // Forward from second EX stage
    end
end

endmodule