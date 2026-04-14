module shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 2'b00;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {1'b0, data_out[1:1]};
    end
end

endmodule