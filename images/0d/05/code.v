module pipeline_register (
    input wire clk,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_reg;

    always @(posedge clk) begin
        stage1_reg <= data_in;    // Stage 1: Capture input data
        data_out <= stage1_reg + 1; // Stage 2: Increment and output
    end
endmodule