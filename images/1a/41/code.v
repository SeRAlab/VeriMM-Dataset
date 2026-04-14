module shift_register (
    input clk,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk) begin
        data_out <= {data_out[0], data_in};
    end
endmodule