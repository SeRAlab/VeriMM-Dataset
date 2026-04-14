module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);
    reg [31:0] fetch_stage;
    reg [31:0] decode_stage;
    reg [31:0] execute_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fetch_stage <= 32'b0;
            decode_stage <= 32'b0;
            execute_stage <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            fetch_stage <= instruction_in;
            decode_stage <= fetch_stage;
            execute_stage <= decode_stage;
            instruction_out <= execute_stage;
        end
    end
endmodule