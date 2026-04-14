module sync_reset(    
    input clk,
    input rst,
    input data_in,
    output reg data_out
);

always @(posedge clk) begin
    if (rst)
        data_out <= 0;
    else
        data_out <= data_in;
end

endmodule