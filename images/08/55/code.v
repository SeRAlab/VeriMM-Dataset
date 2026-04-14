module instruction_pipeline (
    input clk,
    input reset,
    input [15:0] instruction_in,
    output reg [15:0] fetched_instruction,
    output reg [15:0] decoded_instruction,
    output reg [15:0] executed_result,
    output reg fetch_valid,
    output reg decode_valid,
    output reg execute_valid
);
    reg [1:0] state;
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
            fetched_instruction <= 16'b0;
            decoded_instruction <= 16'b0;
            executed_result <= 16'b0;
            fetch_valid <= 0;
            decode_valid <= 0;
            execute_valid <= 0;
        end else begin
            case (state)
                FETCH: begin
                    fetched_instruction <= instruction_in;
                    fetch_valid <= 1;
                    state <= DECODE;
                end
                DECODE: begin
                    decoded_instruction <= fetched_instruction; // Simple pass-through for this example
                    decode_valid <= 1;
                    state <= EXECUTE;
                end
                EXECUTE: begin
                    executed_result <= decoded_instruction + 1; // Simple increment for this example
                    execute_valid <= 1;
                    state <= FETCH; // Go back to fetch next instruction
                end
            endcase
        end
    end
endmodule