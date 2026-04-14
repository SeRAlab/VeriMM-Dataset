module pipeline_7_stage(
    input clk,
    input rst,
    input data_in,
    output reg data_out
);
    reg [6:0] pipeline_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_reg <= 7'b0;
            data_out <= 1'b0;
        end else begin
            pipeline_reg <= {pipeline_reg[5:0], data_in};
            data_out <= pipeline_reg[6];
        end
    end
endmodule