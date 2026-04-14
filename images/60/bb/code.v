module edge_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        prev_state <= 0;
    else
        prev_state <= data_in;
end

always @(*) begin
    if (~rst_n)
        data_out = 0;
    else if (data_in == 1 && prev_state == 0)
        data_out = 1;
    else
        data_out = 0;
end

endmodule