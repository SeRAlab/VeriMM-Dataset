module pipeline_2stage(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] stage1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage1 <= 8'b0;
        data_out <= 8'b0;
    end else begin
        stage1 <= data_in;  // Stage 1
        data_out <= stage1; // Stage 2
    end
end

endmodule