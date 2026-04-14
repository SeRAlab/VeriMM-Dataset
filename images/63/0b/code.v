module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    reg [63:0] adda_reg1, adda_reg2, adda_reg3;
    reg [63:0] addb_reg1, addb_reg2, addb_reg3;
    reg i_en_reg1, i_en_reg2, i_en_reg3;

    reg [64:0] sum_stage1, sum_stage2, sum_stage3;

    // Stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg1 <= 64'b0;
            addb_reg1 <= 64'b0;
            i_en_reg1 <= 1'b0;
        end else if (i_en) begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;
        end
    end

    always @* begin
        sum_stage1 = {1'b0, adda_reg1} + {1'b0, addb_reg1};
    end

    // Stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg2 <= 64'b0;
            addb_reg2 <= 64'b0;
            i_en_reg2 <= 1'b0;
            sum_stage2 <= 65'b0;
        end else begin
            adda_reg2 <= adda_reg1;
            addb_reg2 <= addb_reg1;
            i_en_reg2 <= i_en_reg1;
            sum_stage2 <= sum_stage1;
        end
    end

    // Stage 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg3 <= 64'b0;
            addb_reg3 <= 64'b0;
            i_en_reg3 <= 1'b0;
            sum_stage3 <= 65'b0;
        end else begin
            adda_reg3 <= adda_reg2;
            addb_reg3 <= addb_reg2;
            i_en_reg3 <= i_en_reg2;
            sum_stage3 <= sum_stage2;
        end
    end

    // Output Stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            result <= sum_stage3;
            o_en <= i_en_reg3;
        end
    end

endmodule
