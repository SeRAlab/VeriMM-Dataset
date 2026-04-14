module pipeline_processor (
    input clk,
    input reset,
    input [3:0] opcode, // Opcode: 0000 - ADD, 0001 - SUB, 0010 - AND, 0011 - OR, 0100 - NOT
    input [4:0] src1, src2, // Source registers
    output reg [31:0] result, // Result output
    output reg valid // Output valid signal
);
    reg [31:0] reg_file [0:31]; // Register file
    reg [31:0] if_id_inst, id_ex_src1, id_ex_src2; // Pipeline registers

    // Stage 1: Instruction Fetch
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id_inst <= 0;
            valid <= 0;
        end else begin
            if_id_inst <= {opcode, src1, src2}; // Fetch instruction
            valid <= 1; // Set valid signal
        end
    end

    // Stage 2: Instruction Decode
    always @(posedge clk) begin
        id_ex_src1 <= reg_file[if_id_inst[9:5]]; // Decode src1
        id_ex_src2 <= (opcode[3:0] == 4'b0100) ? 0 : reg_file[if_id_inst[4:0]]; // Decode src2 (0 for NOT)
    end

    // Stage 3: Execute
    always @(posedge clk) begin
        case (if_id_inst[15:12]) // Instruction execution based on opcode
            4'b0000: result <= id_ex_src1 + id_ex_src2; // ADD
            4'b0001: result <= id_ex_src1 - id_ex_src2; // SUB
            4'b0010: result <= id_ex_src1 & id_ex_src2; // AND
            4'b0011: result <= id_ex_src1 | id_ex_src2; // OR
            4'b0100: result <= ~id_ex_src1; // NOT
            default: result <= 0;
        endcase
    end
endmodule