module data_forwarding_unit(
    input wire [4:0] rs1, // Source register 1
    input wire [4:0] rs2, // Source register 2
    input wire [4:0] rd_EX, // Destination register from EX stage
    input wire [4:0] rd_MEM, // Destination register from MEM stage
    input wire reg_write_EX, // Write enable for EX stage
    input wire reg_write_MEM, // Write enable for MEM stage
    output reg [1:0] forwardA, // Forwarding for rs1
    output reg [1:0] forwardB  // Forwarding for rs2
);

always @(*) begin
    // Default forwarding values
    forwardA = 2'b00; 
    forwardB = 2'b00;

    // Check for forwarding for rs1
    if (reg_write_EX && (rd_EX != 0) && (rd_EX == rs1)) begin
        forwardA = 2'b10; // Forward from EX stage
    end else if (reg_write_MEM && (rd_MEM != 0) && (rd_MEM == rs1)) begin
        forwardA = 2'b01; // Forward from MEM stage
    end

    // Check for forwarding for rs2
    if (reg_write_EX && (rd_EX != 0) && (rd_EX == rs2)) begin
        forwardB = 2'b10; // Forward from EX stage
    end else if (reg_write_MEM && (rd_MEM != 0) && (rd_MEM == rs2)) begin
        forwardB = 2'b01; // Forward from MEM stage
    end
end
endmodule