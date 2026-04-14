module DataForwardingUnit (
    input [4:0] rs1, // Source register 1
    input [4:0] rs2, // Source register 2
    input [4:0] rd_EX, // Destination register from EX stage
    input [4:0] rd_MEM, // Destination register from MEM stage
    input EX_valid, // Valid signal if EX stage writes to rd_EX
    input MEM_valid, // Valid signal if MEM stage writes to rd_MEM
    output reg [1:0] forwardA, // Forwarding signal for rs1
    output reg [1:0] forwardB  // Forwarding signal for rs2
);

always @(*) begin
    // Default forwarding signals
    forwardA = 2'b00;
    forwardB = 2'b00;

    // Forwarding for rs1
    if (EX_valid && rs1 == rd_EX) begin
        forwardA = 2'b10; // Forward from EX stage
    end
    else if (MEM_valid && rs1 == rd_MEM) begin
        forwardA = 2'b01; // Forward from MEM stage
    end

    // Forwarding for rs2
    if (EX_valid && rs2 == rd_EX) begin
        forwardB = 2'b10; // Forward from EX stage
    end
    else if (MEM_valid && rs2 == rd_MEM) begin
        forwardB = 2'b01; // Forward from MEM stage
    end
end

endmodule