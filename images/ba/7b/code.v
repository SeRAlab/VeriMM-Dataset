module verified_shift_register(
    input clk,
    input rst_n,
    input data_in,
    
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 8'b00000000;
        else
            data_out <= {data_in, data_out[7:1]};
    end
endmodule