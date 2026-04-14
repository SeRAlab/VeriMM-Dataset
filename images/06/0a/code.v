module data_forwarding_unit(
    input [4:0] EX_MEM_reg,       // Register output from EX stage
    input [4:0] MEM_WB_reg,       // Register output from MEM stage
    input [4:0] rs1,              // Source register 1
    input [4:0] rs2,              // Source register 2
    output reg forwardA,          // Forwarding signal for rs1
    output reg forwardB           // Forwarding signal for rs2
);
    always @(*) begin
        // Initialize forwarding signals
        forwardA = 2'b00; // No forwarding
        forwardB = 2'b00; // No forwarding

        // Check for forwarding conditions for rs1
        if (EX_MEM_reg != 0 && EX_MEM_reg == rs1) forwardA = 2'b10; // Forward from EX stage
        else if (MEM_WB_reg != 0 && MEM_WB_reg == rs1) forwardA = 2'b01; // Forward from MEM stage

        // Check for forwarding conditions for rs2
        if (EX_MEM_reg != 0 && EX_MEM_reg == rs2) forwardB = 2'b10; // Forward from EX stage
        else if (MEM_WB_reg != 0 && MEM_WB_reg == rs2) forwardB = 2'b01; // Forward from MEM stage
    end
endmodule