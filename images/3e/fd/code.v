module shift_register (
    input clk,
    input rst,
    input load,
    input [15:0] data_in,
    input msb_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 16'b0;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {msb_in, data_out[15:1]};
    end
end

endmodule