module pipeline_processor(
    input clk,
    input rst,
    input [1:0] instruction_in,
    output reg [1:0] result_out
);
    reg [1:0] fetch_stage;
    reg [1:0] decode_stage;
    reg [1:0] execute_stage;
    reg [1:0] memory_stage;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fetch_stage <= 2'b00;
            decode_stage <= 2'b00;
            execute_stage <= 2'b00;
            memory_stage <= 2'b00;
            result_out <= 2'b00;
        end else begin
            // Pipeline stages
            fetch_stage <= instruction_in;
            decode_stage <= fetch_stage;
            execute_stage <= decode_stage;
            memory_stage <= execute_stage;
            result_out <= memory_stage; // Assuming simple pass-through for the result
        end
    end
endmodule