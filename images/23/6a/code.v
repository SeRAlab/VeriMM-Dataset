module pipelined_processor (
    input clk,
    input reset,
    input [3:0] instruction,
    output reg [3:0] reg0_out,
    output reg [3:0] reg1_out
);
    reg [3:0] reg_file [0:3]; // Register file with 4 registers
    reg [3:0] IF_ID_inst;
    reg [3:0] ID_EX_inst;
    reg [3:0] EX_MEM_inst;
    reg [3:0] MEM_WB_inst;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_file[0] <= 4'b0000;
            reg_file[1] <= 4'b0000;
            reg_file[2] <= 4'b0000;
            reg_file[3] <= 4'b0000;
            IF_ID_inst <= 4'b0000;
            ID_EX_inst <= 4'b0000;
            EX_MEM_inst <= 4'b0000;
            MEM_WB_inst <= 4'b0000;
        end else begin
            // Pipeline stages
            IF_ID_inst <= instruction; // IF stage
            ID_EX_inst <= IF_ID_inst; // ID stage
            EX_MEM_inst <= ID_EX_inst; // EX stage

            // Simple execution logic: assuming the instruction is a register write
            reg_file[0] <= EX_MEM_inst; // Write to reg0 for simplicity
            MEM_WB_inst <= reg_file[0]; // MEM stage
            reg0_out <= MEM_WB_inst; // WB stage output
            reg1_out <= reg_file[1]; // Output reg1
        end
    end
endmodule