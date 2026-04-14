module data_sampler(    
    input clk,
    input data_in,
    output reg data_out
);

always @(posedge clk) begin
    data_out <= data_in;
end

endmodule