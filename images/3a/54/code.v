module instruction_pipeline(
    input clk,
    input reset,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out
);
    reg [7:0] fetch_reg;
    reg [7:0] decode_reg;
    reg [7:0] execute_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fetch_reg <= 8'b0;
            decode_reg <= 8'b0;
            execute_reg <= 8'b0;
            instruction_out <= 8'b0;
        end else begin
            fetch_reg <= instruction_in;
            decode_reg <= fetch_reg;
            execute_reg <= decode_reg;
            instruction_out <= execute_reg;
        end
    end
endmodule