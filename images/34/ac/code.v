module pipeline (
    input wire clk,
    input wire [7:0] in_data,
    output reg [7:0] out_data
);
    reg [7:0] stage1_reg;

    always @(posedge clk) begin
        stage1_reg <= in_data;       // Stage 1: register input
        out_data <= stage1_reg + 5;  // Stage 2: process and register output
    end
endmodule