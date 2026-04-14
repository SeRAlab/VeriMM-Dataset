module instruction_pipeline (
    input clk,
    input rst,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out,
    output reg fetch_enable,
    output reg decode_enable,
    output reg execute_enable
);
    reg [7:0] instruction_reg;
    reg [1:0] state; // 0: fetch, 1: decode, 2: execute

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_reg <= 8'b0;
            state <= 2'b00;
            fetch_enable <= 1'b0;
            decode_enable <= 1'b0;
            execute_enable <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    instruction_reg <= instruction_in;
                    fetch_enable <= 1'b1;
                    decode_enable <= 1'b0;
                    execute_enable <= 1'b0;
                    state <= 2'b01; // Move to decode
                end
                2'b01: begin
                    instruction_out <= instruction_reg;
                    fetch_enable <= 1'b0;
                    decode_enable <= 1'b1;
                    execute_enable <= 1'b0;
                    state <= 2'b10; // Move to execute
                end
                2'b10: begin
                    // Simulate execution stage (no actual operation)
                    fetch_enable <= 1'b0;
                    decode_enable <= 1'b0;
                    execute_enable <= 1'b1;
                    state <= 2'b00; // Go back to fetch
                end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule