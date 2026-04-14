module shift_register_8bit(
    input clk,
    input rst_n,
    input load,
    input [7:0] data_in,
    input shift_enable,
    output reg [7:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 8'b00000000;
    end else if (load) begin
        data_out <= data_in;
    end else if (shift_enable) begin
        data_out <= {1'b0, data_out[7:1]};
    end
end

endmodule