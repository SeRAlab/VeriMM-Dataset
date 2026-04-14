module pipeline_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);
    reg [31:0] IF_ID_instr, ID_EX_instr, EX_MEM_instr, MEM_WB_instr;
    reg [31:0] PC;
    reg [2:0] stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            stage <= 0;
        end else begin
            case (stage)
                0: begin // IF
                    IF_ID_instr <= instruction_in;
                    PC <= PC + 4;
                    stage <= 1;
                end
                
                1: begin // ID
                    ID_EX_instr <= IF_ID_instr; // pass to EX stage
                    stage <= 2;
                end

                2: begin // EX
                    EX_MEM_instr <= ID_EX_instr; // pass to MEM stage
                    stage <= 3;
                end

                3: begin // MEM
                    // Memory access logic (simplified)
                    MEM_WB_instr <= EX_MEM_instr; // pass to WB stage
                    stage <= 4;
                end

                4: begin // WB
                    result_out <= MEM_WB_instr; // output result
                    stage <= 0; // reset to IF stage
                end
                
                default: stage <= 0;
            endcase
        end
    end
endmodule