module top_module(
    input [3:0] data_in,
    input [3:0] reg_in,
    input ctrl,
    input clk,
    input reset,
    output reg [3:0] reg_out
);reg [3:0] temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg_out <= 4'b0000;
    end else if (ctrl) begin
        temp <= data_in + reg_in;
        reg_out <= temp;
    end else begin
        reg_out <= reg_in;
    end
end

endmodule