module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire ctrl,
    output reg [3:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 4'b0000;
    end else if (ctrl) begin
        data_out <= data_in;
    end else begin
        data_out <= 4'b0000;
    end
end

endmodule