module data_forwarding(
    input [4:0] src_reg_EX,       // Source register from EX stage
    input [4:0] dest_reg_MEM,      // Destination register from MEM stage
    input [4:0] dest_reg_WB,       // Destination register from WB stage
    input        reg_write_MEM,     // Write enable for MEM stage
    input        reg_write_WB,      // Write enable for WB stage
    output reg   forwardA,          // Forwarding control for operand A
    output reg   forwardB           // Forwarding control for operand B
);

always @(*) begin
    // Default no forwarding
    forwardA = 2'b00;
    forwardB = 2'b00;

    // Forwarding for operand A
    if (reg_write_MEM && (dest_reg_MEM == src_reg_EX)) begin
        forwardA = 2'b10;  // Forward from EX
    end else if (reg_write_WB && (dest_reg_WB == src_reg_EX)) begin
        forwardA = 2'b01;  // Forward from WB
    end

    // Forwarding for operand B
    if (reg_write_MEM && (dest_reg_MEM == src_reg_EX + 1)) begin
        forwardB = 2'b10;  // Forward from EX
    end else if (reg_write_WB && (dest_reg_WB == src_reg_EX + 1)) begin
        forwardB = 2'b01;  // Forward from WB
    end
end

endmodule