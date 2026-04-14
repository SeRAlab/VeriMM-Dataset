module edge_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 0;
        data_out <= 0;
    end else begin
        if (prev_data == 0 && data_in == 1) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
        prev_data <= data_in;
    end
end

endmodule