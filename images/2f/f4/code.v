module pipelined_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);

    reg [31:0] IF_ID_instr, ID_EX_instr, EX_MEM_instr, MEM_WB_instr;
    reg [31:0] ID_EX_data1, ID_EX_data2;
    reg [31:0] EX_MEM_result;
    
    reg [6:0] state;
    parameter FETCH = 0, DECODE = 1, EXECUTE = 2, MEM_ACCESS = 3, WRITE_BACK = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
            result_out <= 0;
        end else begin
            case (state)
                FETCH: begin
                    IF_ID_instr <= instruction_in;
                    state <= DECODE;
                end
                DECODE: begin
                    ID_EX_instr <= IF_ID_instr;
                    ID_EX_data1 <= 32'b0; // Placeholder for data1
                    ID_EX_data2 <= 32'b0; // Placeholder for data2
                    state <= EXECUTE;
                end
                EXECUTE: begin
                    EX_MEM_instr <= ID_EX_instr;
                    if (ID_EX_instr[31:26] == 6'b000000) begin // R-type
                        EX_MEM_result <= ID_EX_data1 + ID_EX_data2; // ADD
                    end
                    state <= MEM_ACCESS;
                end
                MEM_ACCESS: begin
                    // Placeholder for memory access operation
                    state <= WRITE_BACK;
                end
                WRITE_BACK: begin
                    result_out <= EX_MEM_result; // Write back result
                    state <= FETCH; // Go to next instruction
                end
            endcase
        end
    end
endmodule