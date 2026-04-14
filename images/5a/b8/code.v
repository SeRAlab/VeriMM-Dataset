module edge_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        prev_data_in <= 0;
    else
        prev_data_in <= data_in;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 0;
    else if (prev_data_in == 0 && data_in == 1)
        data_out <= 1;
    else
        data_out <= 0;
end

endmodule