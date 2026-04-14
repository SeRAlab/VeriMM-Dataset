module shift_register_8bit
(
    input clk,
    input rst,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'd0;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {1'b0, data_out[7:1]};
    end
end

endmodule