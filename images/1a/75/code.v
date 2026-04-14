module instruction_pipeline (
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg if_active,
    output reg id_active,
    output reg ex_active,
    output reg wb_active
);
    reg [31:0] if_reg, id_reg, ex_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            if_reg <= 32'b0;
            id_reg <= 32'b0;
            ex_reg <= 32'b0;
            instruction_out <= 32'b0;
            if_active <= 0;
            id_active <= 0;
            ex_active <= 0;
            wb_active <= 0;
        end else begin
            // Instruction Fetch Stage
            if_reg <= instruction_in;
            if_active <= 1;

            // Instruction Decode Stage
            id_reg <= if_reg;
            id_active <= 1;

            // Execute Stage
            ex_reg <= id_reg;
            ex_active <= 1;

            // Write Back Stage
            instruction_out <= ex_reg;
            wb_active <= 1;
        end
    end
endmodule