module shift_register_16bit (
    input clk,
    input rst,
    input load,
    input shift_left,
    input [15:0] parallel_data,
    output reg [15:0] reg_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_out <= 16'b0;
    end else if (load) begin
        reg_out <= parallel_data;
    end else if (shift_left) begin
        reg_out <= {reg_out[14:0], 1'b0};
    end else begin
        reg_out <= {1'b0, reg_out[15:1]};
    end
end

endmodule