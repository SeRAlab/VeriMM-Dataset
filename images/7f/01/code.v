module top_module (
    input clk,
    input reset,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else begin
            data_out <= {data_out[6:0], 1'b0};
        end
    end

endmodule