module shift_register(
    input wire clk,
    input wire rst,
    input wire en,
    input wire data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'd0;
    end else if (en) begin
        data_out <= {data_out[6:0], data_in};
    end
end

endmodule