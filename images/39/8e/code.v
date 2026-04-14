module pipelined_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);
    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_instr;
    reg [31:0] EX_MEM_instr;
    reg [31:0] MEM_WB_instr;
    reg [31:0] registers [0:31];

    // Forwarding logic
    wire [31:0] forwarded_data;
    assign forwarded_data = (EX_MEM_instr == ID_EX_instr) ? result_out : 32'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 32'b0;
            ID_EX_instr <= 32'b0;
            EX_MEM_instr <= 32'b0;
            MEM_WB_instr <= 32'b0;
            result_out <= 32'b0;
        end else begin
            // Pipeline stages
            IF_ID_instr <= instruction_in; // IF
            ID_EX_instr <= IF_ID_instr;      // ID
            EX_MEM_instr <= ID_EX_instr;     // EX
            result_out <= (EX_MEM_instr + forwarded_data); // MEM and WB
        end
    end
endmodule