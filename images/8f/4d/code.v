module top_module(
    input clk,
    input shift,
    input [3:0] D,
    output reg Q3
);reg [3:0] reg_data;

always @(posedge clk) begin
    if (shift == 1'b0) begin
        reg_data <= D;
    end else begin
        reg_data <= {reg_data[2:0], D[3]};
    end
end

assign Q3 = reg_data[3];

endmodule