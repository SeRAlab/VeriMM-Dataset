module shift_register(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 4'b0;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {data_out[2:0], 1'b0};
    end
end

endmodule